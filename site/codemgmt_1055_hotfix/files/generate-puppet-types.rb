#!/opt/puppetlabs/puppet/bin/ruby

require 'json'
require 'open3'

NAME = File.basename($0)
PUPPET = '/opt/puppetlabs/bin/puppet'

# Calls puppet generate types in the background, returning an array
# representing the process.
def puppet_generate(options)
  command = [PUPPET,
             "generate types",
             "--environment '#{options[:environment]}'",
             "--environmentpath '#{options[:environmentpath]}'",
             "--modulepath '#{options[:modulepath]}'"].join(' ')

  puts("#{NAME}: Executing #{command} STDIN: #{options[:status]}")
  stdout, stderr, status = Open3.capture3(command, :stdin_data => options[:status])

  [command, stdout, stderr, status]
end

# Return stdout, a list of `setting = value`, one per line for the master.
# Puppet will use settings provided by in_settings to determine final config
# values.
def puppet_config_print(in_settings = {}, out_setting = 'all')
  settings = in_settings.map {|setting, value| "--#{setting} #{value}" }
  command = [PUPPET,
             "config print #{out_setting} --section master",
             *settings].join(' ')

  puts("#{NAME}: Executing #{command}")
  stdout, stderr, status = Open3.capture3(command)
  result = process_command_result([command, stdout, stderr, status])

  raise('Puppet config print failed') unless result[3].success?

  result[1].chomp
end

def process_command_result(info)
  command, stdout, stderr, status = *info

  unless status.success?
    warn("#{NAME}: Command #{command} exited #{status.exitstatus}")
    stdout.each_line do |line|
      warn("#{NAME}: STDOUT --   #{line}")
    end
    stderr.each_line do |line|
      warn("#{NAME}: STDERR --   #{line}")
    end
  end

  [command, stdout, stderr, status]
end

# Assumes a JSON blob on STDIN in the format of:
# {
#   "status": {
#     "deleted_files": [],
#     "new_files": [],
#     "updated_files": [],
#     "all_environments": [
#       "production",
#       "stage",
#       "test",
#       "dev"
#     ],
#     "new_environments": [
#       "test"
#     ],
#     "updated_environments": {
#       "dev": {
#         "deleted_files": [],
#         "new_files": [],
#         "updated_files": [
#           "lib/puppet/type/foo.rb"
#         ]
#       }
#     }
#   },
#   "config": {
#     "codedir_staging": "/etc/puppetlabs/code-staging",
#     "environmentpath_staging": "/etc/puppetlabs/code-staging/environments"
#   }
# }
def parse_args(io)
  stdin = io.read
  info = JSON.load(stdin)

  status = info['status']
  config = info['config']

  codedir_staging = config['codedir_staging']
  environmentpath_staging = config['environmentpath_staging']

  remove_unnecessary_changes!(status, environmentpath_staging)

  unless File.exists?(codedir_staging)
    raise("Cannot find codedir_staging: #{codedir_staging}")
  end

  unless File.exists?(environmentpath_staging)
    raise("Cannot find environmentpath_staging: #{environmentpath_staging}")
  end

  [environmentpath_staging, codedir_staging, status]
end

# There are many reasons for an environment to have new, changed, or
# deleted files that do not require types to be regenerated.
# Calling `puppet generate types` (and the required calls to `puppet
# config print`) are slow, and a considerable speed up can occur if we
# only attempt to generate types when we know types need to be generated.
# We know that files we care about must match 'lib/puppet/type/*.rb'.
# Unfortunately, Ruby doesn't make non-destructively mapping over nested hashes
# especially easy, so for a script of this size we simply edit in place.
def remove_unnecessary_changes!(status, envpath)
  puppet_types_pattern = /.*lib\/puppet\/type\/.*\.rb/

  status['updated_files'].select! {|path| path =~ puppet_types_pattern }
  status['deleted_files'].select! {|path| path =~ puppet_types_pattern }
  status['new_files'].select! {|path| path =~ puppet_types_pattern }

  status['updated_environments'].each do |env_name, env_status_map|
    if File.directory?(File.join(envpath, env_name, '.resource_types'))
      # This isn't our first rodeo, check to see if types have been updated
      env_status_map.each_pair do |status_type, files_list|
        files_list.select! {|path| path =~ puppet_types_pattern }
        if env_status_map[status_type].empty?
          env_status_map.delete(status_type)
          puts "#{NAME}: Ignoring #{status_type} for environment #{env_name}, " +
               "no paths match #{puppet_types_pattern.inspect}"
        end
      end

      if status['updated_environments'][env_name].empty?
        status['updated_environments'].delete(env_name)
        puts "#{NAME}: Ignoring changes in #{env_name}, " +
             "no paths match #{puppet_types_pattern.inspect}"
      end
    elsif !Dir.glob(File.join(envpath, env_name, '**/**/lib/puppet/type/*.rb')).empty?
      # We don't have pre-generated types, and there's existing puppet types,
      # we need to generate all types from scratch
      puts "#{NAME}: Generating types for #{env_name}, " +
           "no type definitions have been generated for pre-existing types"
    else
      # We don't have generated types and no types in the env, do nothing
      status['updated_environments'].delete(env_name)
      puts "#{NAME}: Ignoring changes in #{env_name}, " +
           "no types exist in this environment"
    end
  end
end

def get_settings(output, *settings)
  pattern = Regexp.union(settings)

  output.lines.reduce({}) do |hash, line|
    if match = line.match(/^(#{pattern}) = (.*)$/)
      hash[match[1]] = match[2]
    end

    hash
  end
end

# If anything outside of an environment changed, refresh all environments
def refresh_all_environments?(spec)
  %w{deleted_files new_files updated_files}.any? {|type| not spec[type].empty? }
end

# Gets the modulepath from the environment (using the settings that exist in
# the about to be added environment), gets the "live" environmentpath and
# codedir, then munges the modulepath to remove any hardcoded references to
# the live codedir and environmentpath. Finally runs, `puppet generate`
# with the updated settings, returning an array that represents the command
# processing in the background.
def process_environment(env, envpath, codedir, status = nil)
  live_modulepath = puppet_config_print({environment: env,
                                         environmentpath: envpath,
                                         codedir: codedir},
                                         'modulepath')

  puppet_settings = get_settings(
                      puppet_config_print,
                      'codedir',
                      'environmentpath')

  # We want to ensure that we want to anchor the end of our paths with a '/'
  # so that we match actual directories rather than substrings, for example,
  # without this a live codedir that is a substring of our staging codedir
  # would mange our staging codedir. Eg. with a live codedir of
  # '/etc/puppetlabs/code' and a staging codedir of '/etc/puppetlabs/code-staging'
  # would cause a substitution below of '/etc/puppetlabs/code-staging-staging'
  live_codedir            = puppet_settings['codedir'].chomp('/') + '/'
  live_environmentpath    = puppet_settings['environmentpath'].chomp('/') + '/'
  staging_codedir         = codedir.chomp('/') + '/'
  staging_environmentpath = envpath.chomp('/') + '/'

  staging_modulepath = live_modulepath.
    gsub(live_codedir, staging_codedir).
    gsub(live_environmentpath, staging_environmentpath)

  puppet_generate(environment: env,
                  environmentpath: staging_environmentpath,
                  modulepath: staging_modulepath,
                  status: status)
end

def run!(input)
  envpath, codedir, status = parse_args(input)
  proc_info = []

  if status.select {|k,v| k != 'all_environments' }.all? {|item, info| info.empty? }
    puts "#{NAME}: No new or modified puppet types to generate in any " +
         "environment or within the codedir_staging: #{codedir}"
    exit 0
  end

  # If something changed outside of an environment, refresh all environments
  # regardless of changes within them, otherwise refresh any changed
  # environments - passing in a JSON blob on STDIN that represents the diff -
  # and process any new environments. Fail if any environment fails to
  # generate correctly.
  if refresh_all_environments?(status)
    proc_info += status['all_environments'].map do |env|
      process_environment(env, envpath, codedir)
    end
  else
    proc_info += status['updated_environments'].map do |env, info|
      process_environment(env, envpath, codedir, JSON.generate(info))
    end

    proc_info += status['new_environments'].map do |env|
      process_environment(env, envpath, codedir)
    end
  end

  results = proc_info.map do |info|
    process_command_result(info)
  end

  if results.any? {|result| not result[3].success?}
    raise('Some environments did not generate correctly')
  end
end


run!($stdin)

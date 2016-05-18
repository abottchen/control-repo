require 'net/http'
require 'json'
module Puppet::Parser::Functions
  newfunction(:secure_data, :arity => 2, :type => :rvalue) do |args|
    dir = Dir.pwd
    path = dir + '/files/secure.json'
    file = File.read(path)
    tokens = JSON.parse(file)
    key = tokens[args[0]]['key']
    token = tokens[args[0]]['token']
    if args[1] == 'prod'
      url = URI.parse("https://services.ops.usaa.com/secopssvcs/#{key}/xml")
    elsif args[1] == 'test'
      url = URI.parse("https://test.services.ops.usaa.com/secopssvcs/#{key}/xml")
    else
      raise Puppet::Error, "Ya dun goofed. Please specify an environment (test|prod)"
    end
    return url
#    request = Net::HTTP::Get.new(url)
#    request['SecurityTokenValue'] = token
#    response = Net::HTTP.start(url.hostname, url.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) {|http|
#      output = http.request(request)
#    }
#    return response.body.split('password>')[1].split('</')[0]
  end
end

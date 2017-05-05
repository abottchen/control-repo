Puppet::Type.type(:tmpfile).provide(:bash) do
  def create()
    Puppet.debug("README: creating /tmp/#{@resource[:name]} with contents '#{@resource[:insides]}'")
    File.open("/tmp/#{@resource[:name]}") do |f|
      f.write(@resource[:insides]
    end
    @property_hash[:ensure] = :present
  end

  def destroy()
    Puppet.debug("README: rm /tmp/#{@resource[:name]}")
    `rm /tmp/#{@resource[:name]}`
    @property_hash[:ensure] = :absent
  end

  def exists?()
#    Puppet.debug("README: ls /tmp/#{@resource[:name]}")
#    `ls /tmp/#{@resource[:name]} 2> /dev/null`
#    return $?.exitstatus == 0 ? true && Puppet.debug("README: Exists") : Puppet.debug("README: Doesn't exist") && false
    return @property_hash[:ensure] == :present
  end

  def self.instances
    things = `for i in $(find /tmp/ -maxdepth 1 -type f -printf "%f\n"); do echo "$i,\"$(head -1 /tmp/$i)\""; done 2> /dev/null`.split("\n")
    things.collect do |thing|
      myhash = {}
      myhash[:ensure] = :present
      myhash[:name] = `echo #{thing} | cut -d ',' -f1 | tr -d '\n'`
      myhash[:insides] = `echo #{thing} | cut -d ',' -f2 | tr -d '\n'`
      new(myhash)
    end
  end

  def self.prefetch(resources)
    things = instances
    resources.keys.each do |thing|
      if provider = things.find{ |t| t.name == thing }
        resources[thing].provider = provider
      end
    end
  end

  # Getter (handled with mk_resource_methods
#  def insides
#    @property_hash[:insides]
#  end

  mk_resource_methods()

  # Setter
  def insides=(value)
    Puppet.debug("README: setting insides to '#{value}'")
    `echo #{value} > /tmp/#{resource[:name]}`
    @property_hash[:insides] = value
  end
end

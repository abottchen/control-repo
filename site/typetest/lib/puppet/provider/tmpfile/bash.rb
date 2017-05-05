Puppet::Type.type(:tmpfile).provide(:bash) do
  def create()
    Puppet.debug("README: touch /tmp/#{@resource[:name]}")
    `touch /tmp/#{@resource[:name]}`
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
    return @property_hash[:ensure] == :present ? Puppet.debug("README: Exists") && true : Puppet.debug("README: Doesn't Exist") && false
  end

  def self.instances
    things = `ls /tmp 2> /dev/null`.split("\n")
    things.collect do |thing|
      myhash = {}
      myhash[:ensure] = :present
      myhash[:name] = thing
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
end

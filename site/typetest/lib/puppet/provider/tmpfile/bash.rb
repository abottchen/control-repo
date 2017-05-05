Puppet::Type.type(:tmpfile).provide(:bash) do
  def create()
    Puppet.debug("README: creating /tmp/#{@resource[:name]} with contents '#{@resource[:insides]}'")
    File.open("/tmp/#{@resource[:name]}","w") do |f|
      f.write(@resource[:insides])
    end
    @property_hash[:ensure] = :present
  end

  def destroy()
    Puppet.debug("README: deleting /tmp/#{@resource[:name]}")
    File.delete("/tmp/#{@resource[:name]}")
    @property_hash[:ensure] = :absent
  end

  def exists?()
    return @property_hash[:ensure] == :present
  end

  def self.instances
    things = Dir.entries("/tmp")
    things.delete_if do |thing|
      File.ftype("/tmp/#{thing}") != "file"
    end
    things.collect do |thing|
      myhash = {}
      myhash[:ensure] = :present
      myhash[:name] = thing
      myhash[:insides] = File.read("/tmp/#{thing}")
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
    File.open("/tmp/#{@resource[:name]}","w") do |f|
      f.write(@resource[:insides])
    end
    @property_hash[:insides] = value
  end
end

Puppet::Type.type(:tmpfile).provide(:bash) do
  def create()
    Puppet.debug("README: touch /tmp/#{@resource[:name]}")
    `touch /tmp/#{@resource[:name]}`
  end

  def destroy()
    Puppet.debug("README: rm /tmp/#{@resource[:name]}")
    `rm /tmp/#{@resource[:name]}`
  end

  def exists?()
    Puppet.debug("README: ls /tmp/#{@resource[:name]}")
    `ls /tmp/#{@resource[:name]} 2> /dev/null`
    return $?.exitstatus == 0 ? true && Puppet.debug("README: Exists") : false && Puppet.debug("README: Doesn't exist")
  end
end

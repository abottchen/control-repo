Puppet::Type.type(:tmpfile).provide(:bash) do
  def create()
    `touch /tmp/#{@resource[:name]}`
  end

  def destroy()
    `rm /tmp/#{@resource[:name]}`
  end

  def exists?()
    `ls /tmp/#{@resource[:name]} 2> /dev/null`
    return $?.exitstatus == 0 ? true : false
  end
end

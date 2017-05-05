Puppet::Type.newtype(:tmpfile) do
  ensurable()
  newparam(:name, :namevar => true)
end

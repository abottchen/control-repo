Puppet::Type.newtype(:tmpfile) do
  ensurable()
  newparam(:name, :namevar => true)

  newproperty(:insides)
end

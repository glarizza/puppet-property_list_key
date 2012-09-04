Puppet::Type.newtype(:property_list_key) do
  desc "A Puppet type to model property list files"

  ensurable

  newparam(:key) do
    desc "The name of the key for which we're ensuring absent/present"
  end

  newproperty(:value, :array_matching => :all) do
    desc "The value of the specified key"
  end

  newparam(:domain) do
    desc "The reverse domain of the key in question"
  end

  newparam(:value_type) do
    desc "The value type for the plist key's value"

    defaultto 'string'
  end

  newparam(:name, :namevar => true) do
    desc "Arbitrary namevar"
  end
end

require 'puppet/util/feature'
#Puppet.features.add(:cfpropertylist, :libs => ['CFPropertyList'])
Puppet.features.add(:cfpropertylist) do
  begin
    require 'CFPropertyList'
  rescue ArgumentError
    raise Puppet::Error, "The version of CFPropertyList on the system is too old. " +
      "Please ensure that you have version '2.2.5' of the CFPropertyList gem " +
      "installed on the system."
    return false
  end
  true
end

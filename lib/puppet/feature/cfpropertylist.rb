require 'puppet/util/feature'
#Puppet.features.add(:cfpropertylist, :libs => ['CFPropertyList'])
Puppet.features.add(:cfpropertylist) do
  begin
    require 'cfpropertylist'
  rescue
    false
  end
  true
end

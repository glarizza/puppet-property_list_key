require 'puppet/util/feature'
# Puppet.features.add(:cfpropertylist, :libs => ['CFPropertyList'])
Puppet.features.add(:cfpropertylist) do
  begin
    require 'cfpropertylist'
  rescue LoadError
    false
  end
  true
end

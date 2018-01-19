require 'puppet/util/plist'

Puppet::Type.type(:property_list_key).provide(:cfpropertylist) do
  desc 'A macOS provider for creating property list keys and values'

  def exists?
    return false unless File.file? resource[:path]
    if resource[:path].nil? || resource[:key].nil?
      raise("The 'key' and 'path' parameters are required for the property_list_key type")
    end

    plist = Puppet::Util::Plist.read_plist_file(resource[:path])
    plist.include? resource[:key]
  end

  def create
    if resource[:value_type] == :boolean
      unless resource[:value].first.to_s =~ /(true|false)/i
        raise Puppet::Error, "Valid boolean values are 'true' or 'false', you specified '#{resource[:value].first}'"
      end
    end

    plist = if File.file? resource[:path]
              Puppet::Util::Plist.read_plist_file(resource[:path])
            else
              {}
            end

    case resource[:value_type]
    when :integer
      plist_value = Integer(resource[:value].first)
    when :real
      plist_value = Float(resource[:value].first)
    when :data
      plist_value = CFPropertyList::Blob.new(resource[:value].first)
    when :boolean
      plist_value = if resource[:value].to_s =~ /false/i
                      false
                    else
                      true
                    end
    when :hash, :string
      plist_value = resource[:value].first
    else
      plist_value = resource[:value]
    end

    plist[resource[:key]] = plist_value

    Puppet::Util::Plist.write_plist_file(plist, resource[:path])
  end

  def destroy
    if File.file?(resource[:path])
      plist = Puppet::Util::Plist.read_plist_file(resource[:path])
    else
      return true
    end

    plist.delete(resource[:key])

    Puppet::Util::Plist.write_plist_file(plist, resource[:path])
  end

  def value
    Puppet::Util::Plist.read_plist_file(resource[:path])[resource[:key]]
  end

  def value=(item_value)
    if resource[:value_type] == :boolean
      unless item_value.to_s =~ /(true|false)/i
        raise Puppet::Error, "Valid boolean values are 'true' or 'false', you specified '#{item_value}'"
      end
    end
    plist = Puppet::Util::Plist.read_plist_file(resource[:path])

    # Values out of Puppet are usually strings...except when they aren't.
    # They need to be massaged before writing to the plist
    case resource[:value_type]
    when :integer
      plist[resource[:key]] = Integer(item_value.first)
    when :real
      plist[resource[:key]] = Float(item_value.first)
    when :data
      plist[resource[:key]] = CFPropertyList::Blob.new(item_value.first)
    when :array
      plist[resource[:key]] = item_value
    when :boolean
      plist[resource[:key]] = if item_value.to_s =~ /false/i
                                false
                              else
                                true
                              end
    else
      plist[resource[:key]] = item_value.first
    end

    Puppet::Util::Plist.write_plist_file(plist, resource[:path])
  end
end

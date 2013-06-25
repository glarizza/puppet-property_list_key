require 'pathname'
Puppet::Type.newtype(:property_list_key) do
  desc "A Puppet type to model property list files"

  ensurable

  newparam(:key) do
    desc "The name of the key for which we're ensuring absent/present"
  end

  newproperty(:value, :array_matching => :all) do
    desc "The value of the specified key"

    # Overwriting the insync? method to handle how Puppet string-ifies
    # all passed values. Because array_matching is set to :all, values
    # set in the resource declaration get passed to Puppet wrapped
    # within an array. The two edge cases here are boolean values and
    # integers (you can't pass an integer or boolean using the Puppet
    # DSL - they get cast as strings). Arrays also don't get wrapped
    # inside ANOTHER array since they already are of class Array. As
    # a result, we super up to handle their insync? comparison. Yes,
    # this whole method is all Array's fault <points and sneers>.
    def insync?(is)
      case resource[:value_type]
      when :boolean
        case should.first
        when 'true', true
          [true, 'true'].include?(is.to_s) ? true : false
        when 'false', false
          [false, 'false'].include?(is.to_s) ? true : false
        end
      when :hash, :string
        should.first == is ? true : false
      when :integer
        should.first.to_i == is ? true : false
      else
        super
      end
    end
  end

  newparam(:path) do
    desc "The path of the plist file"

    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise Puppet::Error, "Path must be absolute: #{value}"
      end
    end
  end

  newparam(:value_type) do
    desc "The value type for the plist key's value"

    newvalues('string', 'boolean', 'array', 'hash', 'integer', 'real')
    defaultto 'string'
  end

  newparam(:name, :namevar => true) do
    desc "Arbitrary namevar"
  end
end

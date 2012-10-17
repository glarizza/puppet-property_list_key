##property_list_key

This is a Puppet module that will manage OS X plist files. It's unique from other resources in that it manages individual KEYS and VALUES in a plist file. Because of this, you can have multiple resources for a single file specified in the path attribute.

It's important that you set the value\_type attribute, especially if you're trying to set a value like an integer or a boolean. Also, if you indicate that you're passing a value type of a hash or an array, then you'll need to use that native value type when you're specifying the value (see the below example for the array syntax).

Finally, this type currently can only manage an ENTIRE hash if you specify a value\_type of 'hash'. Ideally, it would be nice to manage individual hash keys/values, but the mechanics of that have yet to be sussed out.

Contact
-------
Gary Larizza <gary@puppetlabs.com>

Usage
-------
        property_list_key { 'test3':
          ensure     => present,
          path       => '/tmp/com.puppetlabs.puppet',
          key        => 'arraytest',
          value      => ['array', 'values'],
          value_type => 'array',
        }

        # Disable Gatekeeper in 10.8
        property_list_key { 'Disable Gatekeeper':
          ensure => present,
          path   => '/var/db/SystemPolicy-prefs.plist',
          key    => 'enabled',
          value  => 'no',
        }

See more usage information in the `tests/property_list.pp` file

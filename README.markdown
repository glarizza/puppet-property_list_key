##property_list_key

This is a Puppet module that will manage OS X plist files. It's unique from other resources in that it manages individual KEYS and VALUES in a plist file. Because of this, you can have multiple resources for a single file specified in the path attribute.

It's important that you set the value\_type attribute, especially if you're trying to set a value like an integer or a boolean. Also, if you indicate that you're passing a value type of a hash or an array, then you'll need to use that native value type when you're specifying the value (see the below example for the array syntax).

Finally, this type currently can only manage an ENTIRE hash if you specify a value\_type of 'hash'. Ideally, it would be nice to manage individual hash keys/values, but the mechanics of that have yet to be sussed out.

## A NOTE FOR MAVERICKS SUPPORT!

Previously, this provider supported the RubyCocoa library that Apple shipped
as part of OS X (which acted as a bridge between Ruby and, well, Cocoa). As
of Mavericks (10.9) and Apple's inclusion of Ruby 2.0.0, Apple has removed
the RubyCocoa library.  Boo.  I'm still shipping the RubyCocoa provider, but
have added a NEW provider, [CFPropertyList](https://github.com/ckruse/CFPropertyList/),
to support another awesome lib for reading/writing binary/XML plists.

### The CFPropertyList Provider

The CFPropertyList provider will work with Ruby 2.0.0, however there's one
little problem: **the version of CFPropertyList that ships with Mavericks
has a bug.**  Due to this bug, I'm requiring that CFPropertyList version
2.2.5 or greater be installed in order to use the CFPropertyList provider
(in fact, if you DON'T have that version or greater installed, Puppet will
raise an error and the provider will not be available).  The way to install
CFPropertyList is to choose ONE of the following methods (i.e. CHOOSE THE
BEST - DON'T TRY TO DO THEM ALL!):

* For [Boxen](https://github.com/boxen/our-boxen) Users, add the following to the `Gemfile` in the root of your Boxen repository:

```
gem 'CFPropertyList',         '>= 2.2.6'
```

This will allow Boxen to pull down the correct version of the gem and load it in Boxen's load path

* For people using the system version of Rubygems, update the version of CFPropertyList with `gem update`:

```
    └(~/src/puppet-property_list_key)▷ sudo /usr/bin/gem update CFPropertyList
    Updating installed gems
    Updating CFPropertyList
    Fetching: CFPropertyList-2.2.6.gem (100%)
    Successfully installed CFPropertyList-2.2.6
    Gems updated: CFPropertyList
```

* For users of Bundler, simply use the Gemfile I've provide to `bundle install` your way to CFPropertyList

```
    └(~/src/puppet-property_list_key)▷ bundle install
```

* For users who are using the system version of Rubygems and don't have CFPropertyList installed, use `gem` to install the version of CFPropertyList you need

```
    └(~/src/puppet-property_list_key)▷sudo /usr/bin/gem install CFPropertyList -v 2.2.6
```

Once you have the correct version of CFPropertyList available, the provider
will be rendered suitable/available and life should get much better! Usage
remains exactly the same whether you're using CFPropertyList or RubyCocoa.

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

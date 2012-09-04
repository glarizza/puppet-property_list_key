property_list_key { 'simple':
  ensure => present,
  domain => '/tmp/com.puppetlabs.puppet',
  key    => 'simple',
  value  => 'value',
}
property_list_key { 'test':
  ensure => present,
  domain => '/tmp/com.puppetlabs.puppet',
  key    => 'hashtest',
  value  => { 'key' => 'value' },
}

property_list_key { 'test3':
  ensure     => present,
  domain     => '/tmp/com.puppetlabs.puppet',
  key        => 'arraytest',
  value      => ['array', 'values'],
  value_type => 'array',
}

property_list_key { 'test2':
  ensure     => present,
  domain     => '/tmp/com.puppetlabs.puppet',
  key        => 'integertest',
  value      => '1',
  value_type => 'integer',
}


include admin::rubygems
include admin::puppet::client
include admin::apt

class { 'admin::clock::synchronized':
  timezone => 'America/Argentina/Buenos_Aires',
}

class { 'acng::client':
  server => '10.0.2.2',
}

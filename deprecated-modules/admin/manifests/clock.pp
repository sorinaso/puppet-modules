class admin::clock::synchronized($timezone) {
  case $::operatingsystem {
  'Ubuntu': {
    class { 'ntp':
      service_enable => true,
      service_ensure => running,
      servers    => ['ntp.ubuntu.com iburst',
                     'pool.ntp.org iburst'],
    }

    class { 'timezone':
      timezone => $timezone,
    }
  }
  default: { fail("${::operatingsystem} not implemented.") }
  }
}
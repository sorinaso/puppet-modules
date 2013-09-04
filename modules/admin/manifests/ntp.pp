class admin::ntp::daemon {
  case $::operatingsystem {
    'Ubuntu': {
      class { 'ntp':
        ensure     => running,
        enable     => true,
        servers    => ['ntp.ubuntu.com iburst',
        'pool.ntp.org iburst'],
      }
    }
    default: { fail("${::operatingsystem} not implemented.") }
  }
}
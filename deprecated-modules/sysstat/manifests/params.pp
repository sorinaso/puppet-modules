class sysstat::params {
  case $::operatingsystem {
    Ubuntu: {
      $package = 'sysstat'
      $service = 'sysstat'
    }
    default: {
      fail("The ${module_name} module is not supported on ${::operatingsystem} OS")
    }
  }
}
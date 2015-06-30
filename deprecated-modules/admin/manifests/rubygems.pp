class admin::rubygems {
  case $::operatingsystem {
    'Ubuntu': {
      package { 'rubygems': }
    }
    default: { fail("${::operatingsystem} not implemented.") }
  }
}
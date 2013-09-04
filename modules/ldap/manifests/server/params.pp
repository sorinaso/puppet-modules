class ldap::server::params {
  case $operatingsystem {
    'Ubuntu': {
      $packages = ['slapd', 'ldap-utils']
      $service  = 'slapd'
    }
    default: { fail("${operatingsystem} OS not supported.") }
  }
}
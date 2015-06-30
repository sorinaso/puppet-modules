class ldap::params {
  case $operatingsystem {
    'Ubuntu': {
      $schema_directory = '/etc/ldap/schema'
    }
    default: { fail("${operatingsystem} OS not supported.") }
  }
}
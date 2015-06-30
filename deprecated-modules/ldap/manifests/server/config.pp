class ldap::server::config {
  include ldap::server

  case $operatingsystem {
    'Ubuntu': { include ldap::server::config::ubuntu }
    default: { fail("${operatingsystem} OS not supported.") }
  }
}

class ldap::server::config::ubuntu {
  if $ldap::server::ldap_port != undef {
    editfile::config { "ldap::server::ubuntu:port":
      path    => '/etc/default/slapd',
      entry   => 'SLAPD_SERVICES',
      sep     => '=',
      ensure  => "\"ldap://127.0.0.1:${ldap::server::ldap_port}/ ldaps:/// ldapi:///\"",
      require => Package[$ldap::server::params::packages],
      notify  => Service[$ldap::server::params::service],
    }
  }
}

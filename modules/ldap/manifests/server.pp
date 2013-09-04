class ldap::server($ldap_port = undef) {
  include ldap::server::params
  include ldap::server::config

  package { $ldap::server::params::packages: }

  service { $ldap::server::params::service:
    ensure  => running,
    enable  => true,
    require => Package[$ldap::server::params::packages],
  }
}
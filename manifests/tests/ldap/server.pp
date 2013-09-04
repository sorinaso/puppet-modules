include ldap::server

assert { "must serve ldap":
  ensure    => 'succeed',
  logoutput => onfailure,
  command   => "/usr/bin/ldapurl|grep 'ldap://:389'",
  require   => Class['ldap::server'],
}

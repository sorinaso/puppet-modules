class { 'ldap::server':
  ldap_port => 6666,
}

assert { "must serve ldap":
  ensure    => 'succeed',
  logoutput => onfailure,
  command   => "nc -w 1 localhost 6666",
  require   => Class['ldap::server'],
}
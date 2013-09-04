include ldap::server

ldap::define::schema { 'test': 
  content => 'test',
}

assert { "must serve ldap":
  ensure    => 'succeed',
  logoutput => onfailure,
  command   => "grep 'test' /etc/ldap/schema/test.schema",
  require   => Ldap::Define::Schema['test'],
}
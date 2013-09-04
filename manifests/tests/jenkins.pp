class { 'jenkins':
  user => 'vagrant',
}

assert { "must serve jenkins":
  ensure        => 'succeed',
  logoutput    => onfailure,
  command      => "/usr/bin/curl -Is http://localhost:8080 | head -n 1",
}
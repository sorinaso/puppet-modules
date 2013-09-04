include sysstat::service

assert { "must serve sysstat":
  ensure       => 'succeed',
  logoutput    => onfailure,
  command      => "/usr/bin/service --status-all | grep sysstat",
  require      => Class['sysstat::service'],
}

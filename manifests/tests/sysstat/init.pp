include sysstat

assert { "must install jenkins":
  ensure       => 'succeed',
  logoutput    => onfailure,
  command      => "/usr/bin/dpkg -l | grep sysstat",
  require      => Class['sysstat'],
}

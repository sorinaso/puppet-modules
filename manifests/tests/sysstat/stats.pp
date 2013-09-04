class { 'sysstat::stats':
  run_every_minutes => 5,
}

assert { "must set sysstat interval":
  ensure       => 'succeed',
  logoutput    => true,
  command      => "cat /etc/cron.d/sysstat",
  require      => Class['sysstat::stats'],
}

class sysstat::stats($ensure = present, $run_every_minutes=5) {
  include sysstat::service
  include sysstat::params

  case $::operatingsystem {
    Ubuntu: {
      include sysstat::stats::ubuntu
    }
    default: {
      fail("The ${module_name} module is not supported on ${::operatingsystem} OS")
    }
  }
}

class sysstat::stats::ubuntu inherits sysstat::stats {
  case $ensure {
    present: { $file_ensure = "true" }
    absent: { $file_ensure = "false" }
    default: { fail('ensure must be present or absent') }
  }

  editfile::config { "sysstat::stats::ubuntu::enabled":
    path    => '/etc/default/sysstat',
    entry   => 'ENABLED',
    sep     => '=',
    ensure  => $file_ensure,
    notify => Class[sysstat::service],
  }

  file { '/etc/cron.d/sysstat':
    content => template('sysstat/ubuntu/etc/cron.d/sysstat.erb'),
    notify => Class[sysstat::service],
  }
}
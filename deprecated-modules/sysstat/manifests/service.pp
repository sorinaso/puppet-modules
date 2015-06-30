class sysstat::service($enable = true) {
  include sysstat

  service { $sysstat::params::service:
    enable => $enable,
    require => Class['sysstat'],
  }
}

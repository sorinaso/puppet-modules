define zabbix::server::config_line($ensure) {
  include zabbix::params

  file_line { "zabbix::server::config_line:${name}":
    path    => $zabbix::params::server_conf_file,
    line    => "${name}=${ensure}",
    match   =>  "^${name}( )*=.*",
    require => Class['zabbix'],
  }
}
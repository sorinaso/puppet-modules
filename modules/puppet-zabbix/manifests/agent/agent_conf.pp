define zabbix::agent::agent_conf($ensure) {
  file_line { "zabbix::agent::agent_conf:${name}":
    path    => $zabbix::agent_conf_file,
    line    => "${name}=${ensure}",
    match   =>  "^${name}( )*=.*",
    require => Class['zabbix'],
  }
}
define zabbix::agent::agentd_conf($ensure) {
  file_line { "zabbix::agent::agentd_conf:${name}":
    path    => $zabbix::agentd_conf_file,
    line    => "${name}=${ensure}",
    match   =>  "^${name}( )*=.*",
    require => Class['zabbix'],
  }
}
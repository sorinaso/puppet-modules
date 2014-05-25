class zabbix::agent::service::ubuntu {
  file { '/etc/init.d/zabbix_agent':
    content => template("zabbix/agent/ubuntu.init_d.erb"),
    mode    => 755,
    owner   => root,
    group   => root,
  }

  Class['zabbix'] -> Class['zabbix::agent::service::ubuntu']
}
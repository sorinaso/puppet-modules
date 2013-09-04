class zabbix::server::service::ubuntu {
  file { '/etc/init.d/zabbix_server':
    content => template("zabbix/server/ubuntu.init_d.erb"),
    mode    => 755,
    owner   => root,
    group   => root,
  }

  Class['zabbix'] -> Class['zabbix::server::service::ubuntu']
}
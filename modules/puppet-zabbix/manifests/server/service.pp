class zabbix::server::service(
$ensure,
$enable
) {
  file { $zabbix::server_service_file:
    content => template($zabbix::server_service_template),
    mode    => 755,
    owner   => root,
    group   => root,
  } ->

  service { $zabbix::server_service_initd_service_name:
    enable => $enable,
    ensure => $ensure,
  }

  Class['zabbix'] -> Class['zabbix::server::service']
}
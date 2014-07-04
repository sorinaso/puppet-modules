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

  service { 'zabbix_server':
    enable => $enable,
    ensure => $ensure,
  }

  Class['::zabbix'] -> Class['::zabbix::server::service']
}
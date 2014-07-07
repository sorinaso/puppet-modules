class zabbix::agent::service(
$ensure = $zabbix::agent::service_ensure,
$enable = $zabbix::agent::service_enable
) {
  file { $zabbix::agent_service_file:
    content => template($zabbix::agent_service_template),
    mode    => 755,
    owner   => root,
    group   => root,
  } ->

  service { $zabbix::agent_service_name:
    enable => $enable,
    ensure => $ensure,
  }

  Class['zabbix'] -> Class['zabbix::agent::service']
}
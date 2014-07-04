class zabbix::server(
$service_enable = true,
$service_ensure = 'running',
$database_provider = 'mysql',
$database_name,
$database_user,
$database_password,
$migrate_initial_data = true
) {
  class { 'zabbix::server::mysql':
    database_name         => $database_name,
    database_user         => $database_user,
    database_password     => $database_password,
    migrate_initial_data  => $migrate_initial_data,
  } ->

  class { 'zabbix::server::config':
    log_file => $zabbix::server_log_file,
  } ->

  class { 'zabbix::server::service':
    ensure => $service_ensure,
    enable => $service_enable,
  }

  case $database_provider {
    'mysql': {}
    default: { fail("database_provider: ${database_provider} not supported.") }
  }


  Class['zabbix'] -> Class['zabbix::server']
}
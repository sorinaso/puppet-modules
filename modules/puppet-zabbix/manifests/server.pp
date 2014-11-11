class zabbix::server(
$service_enable = true,
$service_ensure = 'running',
$log_file = $zabbix::server_log_file,
$database_provider = 'mysql',
$database_name,
$database_user,
$database_password,
$migrate_initial_data = true
) {
  case $database_provider {
    'mysql': {}
    default: { fail("database_provider: ${database_provider} not supported.") }
  }

  class { 'zabbix::server::mysql': } ->

  class { 'zabbix::server::config': } ->

  class { 'zabbix::server::service': }

  Class['zabbix'] -> Class['zabbix::server']
}
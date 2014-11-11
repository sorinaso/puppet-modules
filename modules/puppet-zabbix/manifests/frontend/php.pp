class zabbix::frontend::php(
$php_ini_path = false,
$database_hostname = 'localhost',
$database_port	   = '0',
$database_name,
$database_user,
$database_password,
$zabbix_server_ip = 'localhost',
$zabbix_server_port = '10051',
$zabbix_server_name = 'zabbix_server',
$timezone = 'UTC'
) {
  class { 'zabbix::frontend::php::config': }

  Class['zabbix'] -> Class['zabbix::frontend::php']
}
class zabbix::frontend::php(
$database_hostname = 'localhost',
$database_port	   = '0',
$database_name,
$database_user,
$database_password,
$zabbix_server = 'localhost',
$zabbix_port   = '10051',
$zabbix_name  = '',
$timezone = 'UTC'
) {
  include zabbix
  include zabbix::params

  file { $zabbix::params::php_frontend_zabbix_conf_file:
    content => template($zabbix::params::php_frontend_zabbix_conf_file_template),
    owner   => root,
    group   => root,
    mode    => 644,
  }

  Class['zabbix'] -> Class['zabbix::frontend::php']
}
class zabbix::frontend::php::config(
$php_ini_path = $zabbix::frontend::php::php_ini_path,
$database_hostname = $zabbix::frontend::php::database_hostname,
$database_port = $zabbix::frontend::php::database_port,
$database_name = $zabbix::frontend::php::database_name,
$database_user = $zabbix::frontend::php::database_user,
$database_password = $zabbix::frontend::php::database_password,
$zabbix_server_ip = $zabbix::frontend::php::zabbix_server_ip,
$zabbix_server_port = $zabbix::frontend::php::zabbix_server_port,
$zabbix_server_name = $zabbix::frontend::php::zabbix_server_name,
$timezone = $zabbix::frontend::php::timezone
) {
  file { $zabbix::php_frontend_zabbix_conf_file:
    content => template($zabbix::php_frontend_zabbix_conf_file_template),
    owner   => root,
    group   => root,
    mode    => 644,
  }

  if $php_ini_path != false {
    zabbix::frontend::php::php_ini {
      'post_max_size': ensure => '32M';
      'max_execution_time': ensure => '300';
      'max_input_time': ensure => '300';
      'date.timezone': ensure => $timezone;
    }
  }

  Class['zabbix'] -> Class['zabbix::frontend::php::config']
}
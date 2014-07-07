class zabbix::frontend::php::config(
$database_hostname,
$database_port,
$database_name,
$database_user,
$database_password,
$zabbix_server_ip,
$zabbix_server_port,
$zabbix_server_name
) {
  file { $zabbix::params::php_frontend_zabbix_conf_file:
    content => template($zabbix::params::php_frontend_zabbix_conf_file_template),
    owner   => root,
    group   => root,
    mode    => 644,
  }

  zabbix::frontend::php::php_ini {
    'post_max_size': ensure => '32M';
    'max_execution_time': ensure => '300';
    'max_input_time': ensure => '300';
    'post_max_size': ensure => '32M';
    'post_max_size': ensure => '32M';
    'date.timezone': ensure => $timezone;
  }

  Class['zabbix'] -> Class['zabbix::frontend::config']
}
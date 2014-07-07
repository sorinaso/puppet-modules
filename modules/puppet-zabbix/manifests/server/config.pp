class zabbix::server::config(
$log_file = $zabbix::server::log_file
) {
  file { $log_file:
    ensure  => present,
    owner   => $zabbix::user,
    group   => $zabbix::group,
  } ->

  zabbix::server::config_line {
    'LogFile': ensure  => $log_file;
  }
}
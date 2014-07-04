class zabbix::server::config($log_file) {
  zabbix::server::config_line {
    'LogFile': ensure  => $log_file;
  }
}
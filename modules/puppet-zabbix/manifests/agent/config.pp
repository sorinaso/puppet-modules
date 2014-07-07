class zabbix::agent::config(
$server_ip = $zabbix::agent::server_ip,
$agentd_log_file = $zabbix::agent::agentd_log_file
#$server_active = ''
) {
  zabbix::agent::agent_conf {
    'Server': ensure => $server_ip;
  }

  zabbix::agent::agentd_conf {
    'LogFile': ensure => $agentd_log_file;
  }
}
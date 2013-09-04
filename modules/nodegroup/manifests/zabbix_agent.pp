class nodegroup::zabbix_agent(
$zabbix_server,
$hostname
) {
  class { 'zabbix::agent':
    zabbix_server        => $zabbix_server,
    zabbix_server_active => $zabbix_server,
    hostname             => $hostname,
  }
}
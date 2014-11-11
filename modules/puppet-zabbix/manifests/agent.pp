class zabbix::agent(
$server_ip='127.0.0.1',
#$server_active = '',
$hostname) {
  class { 'zabbix::server::config': } ->

  class { 'zabbix::server::service': }
}
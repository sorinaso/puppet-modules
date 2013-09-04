class { 'zabbix::agent':
  zabbix_server        => '50.116.35.156',
  zabbix_server_active => '50.116.35.156',
  hostname             => 'puppet_testing',
}
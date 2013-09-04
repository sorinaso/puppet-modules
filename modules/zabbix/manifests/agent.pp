class zabbix::agent(
$zabbix_server='127.0.0.1',
$zabbix_server_active = '',
$hostname) {
  include zabbix
  include zabbix::params
  include $zabbix::params::agent_service_module

  file { $zabbix::params::agent_conf_file:
    content => template($zabbix::params::agent_conf_file_template),
  }

  file { $zabbix::params::agentd_conf_file:
    content => template($zabbix::params::agentd_conf_file_template),
  }

  service { 'zabbix_agent':
    enable  => true,
    require => Class[$zabbix::params::agent_service_module],
  }

  Class['zabbix'] -> Class['zabbix::agent']
}
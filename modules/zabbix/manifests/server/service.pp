class zabbix::server::service {
  include zabbix::params
  include $zabbix::params::server_service_module

  service { 'zabbix_server':
    enable  => true,
    require => Class[$zabbix::params::server_service_module],
  }
}
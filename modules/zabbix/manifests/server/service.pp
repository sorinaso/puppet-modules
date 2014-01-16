class zabbix::server::service {
  include zabbix::params
  include $zabbix::params::server_service_module

  service { 'zabbix_server':
    enable  => true,
    ensure  => running,
    require => Class[$zabbix::params::server_service_module],
  }
}
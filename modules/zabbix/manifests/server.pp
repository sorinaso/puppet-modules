class zabbix::server {
  include zabbix
  include zabbix::server::service
  include zabbix::params
}
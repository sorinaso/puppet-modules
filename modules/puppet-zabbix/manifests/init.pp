class zabbix(
  $source,
  $src_path,
  $mysql_required_packages = $zabbix::params::mysql_required_packages,
  $enable_server = false,
  $enable_agent = false,
  $enable_mysql = false
) inherits zabbix::params {
}
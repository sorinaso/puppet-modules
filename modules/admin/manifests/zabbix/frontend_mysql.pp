class admin::zabbix::frontend_mysql(
$database_user_and_name,
$database_password,
$zabbix_url_path,
$zabbix_server = '127.0.0.1',
$web_server='lighttpd',
$timezone) {
  class { 'zabbix::frontend::php':
    database_name     => $database_user_and_name,
    database_user     => $database_user_and_name,
    database_password => $database_password,
    zabbix_server     => $zabbix_server,
    timezone          => $timezone,
  }

  case $web_server {
    'lighttpd': {
      class { 'zabbix::frontend::php::lighttpd':
        path => $zabbix_url_path,
      }
    }
    default: { fail("Web server ${web_server} no implementado." ) }
  }
}

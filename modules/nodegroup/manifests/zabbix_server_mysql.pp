class nodegroup::zabbix_server_mysql(
$database_user_and_name,
$database_password,
$zabbix_url_path,
$timezone) {
  mysql::db { $database_user_and_name:
    user     => $database_user_and_name,
    password => $database_password,
    host     => 'localhost',
    grant    => ['all'],
  }

  class { 'zabbix::server::mysql':
    database_name     => $database_user_and_name,
    database_user     => $database_user_and_name,
    database_password => $database_password,
    require           => Mysql::Db[$database_user_and_name],
  }

  class { 'zabbix::frontend::php':
    database_name     => $database_user_and_name,
    database_user     => $database_user_and_name,
    database_password => $database_password,
    zabbix_server     => '127.0.0.1',
    timezone          => $timezone,
  }

  class { 'zabbix::frontend::php::lighttpd':
    path => $zabbix_url_path,
  }
}
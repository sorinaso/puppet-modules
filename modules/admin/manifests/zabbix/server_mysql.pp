class admin::zabbix::server_mysql(
$database_user_and_name,
$database_password,
$create_database=true) {
  if $create_database {
    mysql::db { $database_user_and_name:
      user     => $database_user_and_name,
      password => $database_password,
      host     => 'localhost',
      grant    => ['all'],
    }
  }

  class { 'zabbix::server::mysql':
    database_name     => $database_user_and_name,
    database_user     => $database_user_and_name,
    database_password => $database_password,
    require           => $create_database ? {
                            true  =>  Mysql::Db[$database_user_and_name],
                            false => undef,
                         },
  }
}

class zabbix::server::mysql(
$database_name = $zabbix::server::database_name,
$database_user = $zabbix::server::database_user,
$database_password = $zabbix::server::database_password,
$migrate_initial_data = $zabbix::server::migrate_initial_data
) {
  $mysql_migrate_sql_cmd = "/usr/bin/mysql -u ${database_user} -p'${database_password}' ${database_name}"
  $check_mysql_table_cmd = "/bin/echo 'show tables' | /usr/bin/mysql -u ${database_user} -p${database_password} ${database_name}|/bin/egrep"
  $schema_migrated_cmd = "${check_mysql_table_cmd} users"
  $data_not_migrated_cmd = "/bin/echo 'select count(*) from users' | /usr/bin/mysql -u ${database_user} -p${database_password} ${database_name} |/bin/egrep '0$'"
  $images_not_migrated_cmd = "/bin/echo 'select count(*) from images' | /usr/bin/mysql -u ${database_user} -p${database_password} ${database_name} |/bin/egrep '0$'"

  if $migrate_initial_data {
    exec { 'zabbix::server::mysql::migrate_schema':
      logoutput => true,
      command   => "${mysql_migrate_sql_cmd} < schema.sql",
      unless    => $schema_migrated_cmd,
      cwd       => $zabbix::share_mysql_path,
      require   => Package[$zabbix::mysql_server_required_packages],
    }

    exec { 'zabbix::server::mysql::migrate_images':
      logoutput => true,
      command   => "${mysql_migrate_sql_cmd}  < images.sql",
      onlyif    => $images_not_migrated_cmd,
      cwd       => $zabbix::share_mysql_path,
      require   => Exec['zabbix::server::mysql::migrate_schema'],
    }

    exec { 'zabbix::server::mysql::migrate_data':
      logoutput => true,
      command   => "${mysql_migrate_sql_cmd} < data.sql",
      onlyif    => $data_not_migrated_cmd,
      cwd       => $zabbix::share_mysql_path,
      require   => Exec['zabbix::server::mysql::migrate_schema'],
    }
  }

  zabbix::server::config_line {
    'DBName': ensure  => $database_name;
    'DBUser': ensure  => $database_user;
    'DBPassword': ensure  => $database_password;
  }

  Class['zabbix'] -> Class['zabbix::server::mysql']
}

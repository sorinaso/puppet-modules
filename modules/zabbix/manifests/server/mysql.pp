class zabbix::server::mysql(
$database_name,
$database_user,
$database_password,
$migrate_initial_data = true) {
  include zabbix::server
  include zabbix::params

  $mysql_cmd = "/usr/bin/mysql -u ${database_user} -p'${database_password}' ${database_name}"

  ensure_resource('package', $zabbix::params::mysql_server_required_packages)

  if $migrate_initial_data {
    exec { 'zabbix::server::mysql::migrate_schema':
      command => "${mysql_cmd} < schema.sql && /bin/cp schema.sql schema.sql.migrated",
      creates => "${zabbix::params::share_mysql_path}/schema.sql.migrated",
      cwd     => $zabbix::params::share_mysql_path,
      require => Package[$zabbix::params::mysql_server_required_packages],
    }

    exec { 'zabbix::server::mysql::migrate_images':
      command => "${mysql_cmd}  < images.sql && /bin/cp images.sql images.sql.migrated",
      creates => "${zabbix::params::share_mysql_path}/images.sql.migrated",
      cwd     => $zabbix::params::share_mysql_path,
      require => Exec['zabbix::server::mysql::migrate_schema'],
    }

    exec { 'zabbix::server::mysql::migrate_data':
      command => "${mysql_cmd} < data.sql && /bin/cp data.sql data.sql.migrated",
      creates => "${zabbix::params::share_mysql_path}/data.sql.migrated",
      cwd     => $zabbix::params::share_mysql_path,
      require => Exec['zabbix::server::mysql::migrate_schema'],
    }
  }

  zabbix::server::config {
    'DBName': ensure  => $database_name;
    'DBUser': ensure  => $database_user;
    'DBPassword': ensure  => $database_password;
  }

  Class['zabbix'] -> Class['zabbix::server::mysql']
}

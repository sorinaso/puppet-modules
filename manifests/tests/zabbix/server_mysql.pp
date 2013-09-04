class { 'mysql::server':
  config_hash => { 'root_password' => 'test' }
}

mysql::db { 'zabbix':
  user     => 'zabbix',
  password => 'zabbix',
  host     => 'localhost',
  grant    => ['all'],
}

class { 'zabbix::server::mysql':
  database_name     => 'zabbix',
  database_user     => 'zabbix',
  database_password => 'zabbix',
  require           => Mysql::Db['zabbix'],
}

service { 'zabbix_server':
  ensure => running,
  enable => true,
  require => Class['zabbix::server::mysql'],
}
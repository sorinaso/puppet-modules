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

class { 'zabbix::frontend::php':
  database_name     => 'zabbix',
  database_user     => 'zabbix',
  database_password => 'zabbix',
}

class { 'zabbix::frontend::php::lighttpd':
  path => '/test_zabbix',
}

package { 'curl': }

exec { 'zabbix-services-restart':
  command => '/usr/bin/service zabbix-server restart ; /usr/bin/service apache2 restart',
  returns => [0, 1],
  user    => 'root',
}

assert::http::status { 'http://localhost/test_zabbix':
  code    => 200,
}

Class['zabbix::server::mysql'] -> Class['zabbix::frontend::php::lighttpd'] ->
Exec['zabbix-services-restart'] -> Assert::Http::Status['http://localhost/test_zabbix']
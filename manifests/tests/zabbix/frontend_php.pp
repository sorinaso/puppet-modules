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

package { 'curl': }

exec { 'zabbix-services-restart':
  command => '/usr/bin/service zabbix-server restart ; /usr/bin/service apache2 restart',
  returns => [0, 1],
  user    => 'root',
}

assert { 'must serve zabbix frontend':
  ensure    => 'succeed',
  logoutput => onfailure,
  command   => "/usr/bin/curl -Is http://localhost/zabbix | head -n 1 | grep 301",
}

Class['zabbix::server::mysql'] -> Class['zabbix::frontend::php'] -> Package['curl'] ->
Exec['zabbix-services-restart'] -> Assert['must serve zabbix frontend']
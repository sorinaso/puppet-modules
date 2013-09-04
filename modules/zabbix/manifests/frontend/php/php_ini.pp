class zabbix::frontend::php::php_ini($php_ini_path) {
  include zabbix::params

  editfile::config { "zabbix::frontend::php::config::php_ini::post_max_size":
    path    => $php_ini_path,
    entry   => 'post_max_size',
    sep     => ' = ',
    ensure  => '32M',
  }

  editfile::config { "zabbix::frontend::php::config::php_ini::max_execution_time":
    path    => $php_ini_path,
    entry   => 'max_execution_time',
    sep     => ' = ',
    ensure  => '300',
  }

  editfile::config { "zabbix::frontend::php::config::php_ini::max_input_time":
    path    => $php_ini_path,
    entry   => 'max_input_time',
    sep     => ' = ',
    ensure  => '300',
  }

  editfile::config { "zabbix::frontend::php::config::php_ini::date.timezone":
    path    => $php_ini_path,
    entry   => 'date.timezone',
    sep     => ' = ',
    ensure  => "'${zabbix::frontend::php::timezone}'",
  }

  Class['zabbix::frontend::php'] -> Class['zabbix::frontend::php::php_ini']
}
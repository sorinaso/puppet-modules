define zabbix::frontend::php::php_ini($ensure) {
  file_line { "zabbix::frontend::php::php_ini:${name}":
    path  => $zabbix::frontend::php::config::php_ini_path,
    line  => "${name}=${ensure}",
    match => "^[;]*${name}.*=.*",
  }
}

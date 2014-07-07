define zabbix::frontend::php::php_ini($ensure) {
  file_line { "zabbix::frontend::php::php_ini:${name}":
    path    => $zabbix::$php_ini_file,
    line    => "${name}=${ensure}",
    match   =>  "^${name}( )*=.*",
    require => Class['zabbix'],
  }
}

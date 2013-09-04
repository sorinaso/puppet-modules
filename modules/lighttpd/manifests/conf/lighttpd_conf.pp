define lighttpd::config::lighttpd_conf($ensure) {
  include lighttpd::params

  editfile::config { "lighttpd::config::lighttpd_conf:${name}":
    path    => $zabbix::params::conf_file,
    entry   => $name,
    sep     => ' = ',
    ensure  => $ensure,
    require => Class['lighttpd'],
  }
}

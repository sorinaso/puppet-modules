define zabbix::server::config($ensure) {
  include zabbix::params

  editfile { "zabbix::server::config:${name}":
    path    => $zabbix::params::server_conf_file,
    match   =>  "/(# )*${name}=.*/",
    ensure  => "${name}=${ensure}",
    require => Class['zabbix'],
  }
}
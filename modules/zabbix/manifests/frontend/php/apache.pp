class zabbix::frontend::php::apache {
  include zabbix::params

  file { $zabbix::params::php_frontend_apache_conf_file:
    content => template($zabbix::params::php_frontend_apache_conf_file_template),
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    notify  => Service[$zabbix::params::php_frontend_apache_service],
  }

  service { $zabbix::params::php_frontend_apache_service:
    ensure => 'running',
    enable => true,
  }

  Class['zabbix::frontend::php'] -> Class['zabbix::frontend::php::apache']
}
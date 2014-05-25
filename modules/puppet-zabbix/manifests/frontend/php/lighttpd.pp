class zabbix::frontend::php::lighttpd($path = 'zabbix') {
  include zabbix::params
  include lighttpd::params

  package { $zabbix::params::php_frontend_lighttpd_required_packages: }

  class { '::lighttpd':
    service_enable  => true,
    require         => Package[$zabbix::params::php_frontend_lighttpd_required_packages],
  }

  lighttpd::module { $zabbix::params::php_frontend_lighttpd_required_modules: }

  class { 'zabbix::frontend::php::php_ini':
    php_ini_path => $zabbix::params::php_ini_cgi_path,
    notify       => Service[$::lighttpd::params::service],
    require      => Package[$zabbix::params::php_frontend_lighttpd_required_packages],
  }

  file { "${zabbix::params::php_frontend_lighttpd_document_root}/${path}":
    ensure  => link,
    target  => $zabbix::params::share_php_frontend_path,
    require => Class['::lighttpd'],
  }

  Class['zabbix::frontend::php'] -> Class['zabbix::frontend::php::lighttpd']
}
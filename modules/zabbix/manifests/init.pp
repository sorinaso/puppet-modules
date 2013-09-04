class zabbix {
  include zabbix::params

  package { $zabbix::params::required_packages: }

  $copy_database_path = "/bin/cp -r ${zabbix::params::src_database_path} ${zabbix::params::share_path}/"
  $copy_frontends_path = "/bin/cp -r ${zabbix::params::src_frontends_path} ${zabbix::params::share_path}/"

  cmmi { 'zabbix':
    #download        => $zabbix::params::source_url,
    source          => $zabbix::params::source_module_file,
    creates         => $zabbix::params::server_bin,
    configure_cmd   => 'configure --enable-server --enable-agent --with-mysql',
    require         => Package['libmysqlclient-dev'],
    rm_build_folder => false,
  }

  exec { $copy_database_path:
    creates => $zabbix::params::share_database_path,
    require => Cmmi['zabbix'],
  }

  exec { $copy_frontends_path:
    creates => $zabbix::params::share_frontends_path,
    require => Cmmi['zabbix'],
  }

  exec { "/bin/rm -r ${zabbix::params::src_path}":
    require => [Cmmi['zabbix'], Exec[$copy_database_path], Exec[$copy_frontends_path]],
    onlyif  => "/usr/bin/test -d ${zabbix::params::src_path}",
  }

  group { 'zabbix':
    ensure => present,
  }

  user { 'zabbix':
    gid     => 'zabbix',
    ensure  => present,
  }

  file { $zabbix::params::log_path:
    ensure  => directory,
    owner   => 'zabbix',
    group   => 'zabbix',
    require => [User['zabbix'], Group['zabbix']],
  }
}
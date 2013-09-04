class eggproxy(
$enable_service = true,
$pypi_index='http://pypi.python.org/simple',
$bind_address='127.0.0.1',
$port=8888) {
  include eggproxy::params

  package { $eggproxy::params::dependencies:
    ensure => installed,
  }

  package { 'collective.eggproxy':
    ensure    => '74c262a025993e7dc2074462429f51d38517172c',
    provider  => 'pip',
    source    => 'git+git://github.com/camptocamp/collective.eggproxy.git',
    require   => Package[$eggproxy::params::dependencies],
  }

  file { $eggproxy::params::cache_directory:
    ensure => directory,
  }

  file { $eggproxy::params::conf_file:
    content => template("eggproxy/eggproxy.conf.erb"),
    notify  => Service[$eggproxy::params::service],
  }

  class { $eggproxy::params::service_module:
    enable => $enable_service,
  }
}
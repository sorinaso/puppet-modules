class apache(
$service_enable = true,
$service_ensure = running,
$conf_template = undef
) inherits apache::params {
  package { $apache::params::package:
      ensure => 'installed',
  }

  service { $apache::params::service:
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => Package[$apache::params::package],
  }

  if $conf_template {
    file { $apache::params::conf_file:
      content => $conf_template,
      require => Package[$apache::params::package],
    }
  }
}

class apache(
$ensure = present,
$package = $apache::params::package,
$package_ensure = $ensure,
$service = $apache::params::service,
$service_enable = true,
$service_ensure = running,
$service_external = false,
$conf_template = undef
) inherits apache::params {
  package { $package:
      ensure => $package_ensure,
  }

  if !$service_external and $ensure == present {
    service { $service:
      ensure  => $service_ensure,
      enable  => $service_enable,
      require => Package[$apache::params::package],
    }
  }

  if $conf_template {
    file { $apache::params::conf_file:
      content => $conf_template,
      require => Package[$apache::params::package],
      notify  => Service[$service],
    }
  }
}

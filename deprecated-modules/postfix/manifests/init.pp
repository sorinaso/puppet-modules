class postfix($ensure = present, $enable = false) inherits postfix::params {
  # Postfix package.
  package { $postfix::params::package:
    ensure => $ensure,
  }

  # Postfix service.
  service { $postfix::params::service:
    enable  => $enable,
    require => Package[$postfix::params::package]
  }
}
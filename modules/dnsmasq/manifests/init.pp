class dnsmasq($ensure = present) {
  include dnsmasq::params

  package { $dnsmasq::params::package:
    ensure => $ensure,
  }

  service { $dnsmasq::params::service:
    enable  => true,
    ensure  => running,
    require => Package[$dnsmasq::params::package],
  }
}
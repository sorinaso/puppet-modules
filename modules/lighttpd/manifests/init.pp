class lighttpd(
$ensure = present,
$service_enable = true,
$document_root = $lighttpd::params::document_root)
inherits lighttpd::params {
  # Package.
  package { $lighttpd::params::packages:
    ensure => $ensure,
  }

  # Enable server if must.
  if $service_enable {
    service { $lighttpd::params::service:
      enable  => true,
      ensure  => running,
      require => Package[$lighttpd::params::packages],
    }
  }
}
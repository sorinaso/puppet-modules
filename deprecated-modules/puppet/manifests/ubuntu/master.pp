# == Class: puppet::ubuntu::master
#
# Esta clase crea un puppet master en ubuntu.                  .
#
# === Authors
#
# Alejandro Souto <sorinaso@gmail.com>
#
class puppet::ubuntu::master($ensure = latest) {
  include puppet::ubuntu::repo

  # We install the package.
  package { 'puppetmaster':
    ensure  => $ensure,
    require => Class['puppet::ubuntu::repo'],
  }

  # Ensure Service running.
  service { "puppetmaster":
    ensure  => "running",
    enable  => "true",
    require => Package["puppetmaster"],
  }
}
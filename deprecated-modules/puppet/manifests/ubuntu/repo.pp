# == Class: puppet::ubuntu::repo
#
# Esta clase agrega el repositorio de puppet a ubuntu.
#
# === Authors
#
# Alejandro Souto <sorinaso@gmail.com>
#
class puppet::ubuntu::repo {
  apt::source { 'puppetlabs-main':
    location   => 'http://apt.puppetlabs.com',
    repos      => 'main',
    key        => '4BD6EC30',
    key_server => 'pgp.mit.edu',
  }

  apt::source { 'puppetlabs-dependencies':
    location   => 'http://apt.puppetlabs.com',
    repos      => 'dependencies',
    key        => '4BD6EC30',
    key_server => 'pgp.mit.edu',
  }
}
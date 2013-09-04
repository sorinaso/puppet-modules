# == Class: puppet
#
# Puppet client.
#
# === Authors
#
# Alejandro Souto <alejandro@panaldeideas.com>
#
class puppet::client($ensure = latest) {
  case $operatingsystem {
    'Ubuntu': {
      class { 'puppet::ubuntu::client':
        ensure => $ensure,
      }
    }
    default: { fail("${operatingsystem} OS is not supported.") }
  }
}
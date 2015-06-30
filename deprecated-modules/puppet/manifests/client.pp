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
    'ubuntu': {
      class { 'puppet::ubuntu::client':
        ensure => $ensure,
      }
    }
    default: { fail("${operatingsystem} OS is not supported.") }
  }
}
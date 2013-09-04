# == Class: puppet
#
# Puppet master.
#
# === Authors
#
# Alejandro Souto <alejandro@panaldeideas.com>
#
class puppet::master($ensure = latest) {
  case $operatingsystem {
    'Ubuntu': {
      class { 'puppet::ubuntu::master':
        ensure => $ensure,
      }
    }
    default: { fail("${operatingsystem} OS is not supported.") }
  }
}
# == Define: ssh
#
# SSH.
#
# === Authors
#
# Alejandro Souto <alejandro@panaldeideas.com>
class ssh::params {
  case $::osfamily {
    'Debian': {
      $client_package = 'openssh-client'
      $server_package = 'openssh-server'
      $server_service = 'sshd'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} Debian")
    }
  }
}
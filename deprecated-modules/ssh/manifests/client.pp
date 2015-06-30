# == Define: ssh::client
#
# SSH.
#
# === Authors
#
# Alejandro Souto <alejandro@panaldeideas.com>
class ssh::client {
  include ssh::params

  package { [$ssh::params::package_client]: }
}
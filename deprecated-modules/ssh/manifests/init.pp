# == Define: ssh
#
# SSH.
#
# === Authors
#
# Alejandro Souto <alejandro@panaldeideas.com>
class ssh inherits ssh::params {
  package { [$ssh::params::package_client]: }
  include ssh::server
}
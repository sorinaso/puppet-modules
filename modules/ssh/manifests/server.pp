class ssh::server {
  include ssh::params

  package { [$ssh::params::package_server]: }
}
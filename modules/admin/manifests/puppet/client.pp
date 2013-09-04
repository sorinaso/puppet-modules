class admin::puppet::client {
  include admin::puppet::params

  class { '::puppet::client':
    ensure => $admin::puppet::params::version,
  }
}
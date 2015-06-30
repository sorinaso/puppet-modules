class admin::puppet::master {
  include admin::puppet::params

  class { '::puppet::master':
    ensure => $admin::puppet::params::version,
  }
}
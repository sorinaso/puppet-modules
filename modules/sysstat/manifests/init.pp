class sysstat($ensure=present) {
  include sysstat::params

  package { $sysstat::params::package:
    ensure  => $ensure,
  }
}
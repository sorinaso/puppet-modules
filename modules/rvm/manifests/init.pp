class rvm {
  package { 'curl': ensure => installed }

  exec { 'rvm-install-system-wide':
    command   => '/usr/bin/curl -L https://get.rvm.io | bash -s stable --autolibs=enabled',
    require   => Package['curl'],
    creates   => '/usr/local/rvm/bin/rvm',
    logoutput => on_failure,
  }
}
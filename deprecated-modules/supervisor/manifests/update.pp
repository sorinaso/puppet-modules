class supervisor::update {
  include supervisor

  exec { 'supervisor::update':
    command     => '/usr/bin/supervisorctl update',
    logoutput   => on_failure,
    refreshonly => true,
    user        => $supervisor::params::user,
    #require     => Service[$supervisor::params::system_service],
  }
}

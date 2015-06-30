class supervisor::params {
  case $::operatingsystem {
    'ubuntu','debian': {
      $conf_file      = '/etc/supervisor/supervisord.conf'
      $conf_dir       = '/etc/supervisor'
      $system_service = 'supervisor'
      $package        = 'supervisor'
      $user           = 'root'
    }
    'centos','fedora','redhat': {
      $conf_file      = '/etc/supervisord.conf'
      $conf_dir       = '/etc/supervisord.d'
      $system_service = 'supervisord'
      $package        = 'supervisor'
      $user           = 'root'
    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }
}

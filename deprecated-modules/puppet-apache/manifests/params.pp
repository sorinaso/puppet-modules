class apache::params {
  case $osfamily {
    'Debian': {
      $conf_directory = '/etc/apache2'
      $conf_file = "${conf_directory}/apache2.conf"
      $package = 'apache2'
      $service = 'apache2'
    }
    default: { fail("Familia ${osfamily} no soportada") }
  }
}
class lighttpd::params {
  case $::operatingsystem {
    'Ubuntu': {
      $os_postfix = 'ubuntu'
      $packages = 'lighttpd'
      $service = 'lighttpd'
      $activate_module_module = 'lighttpd::module::ubuntu'
      $document_root = '/var/www'
      $conf_file = '/etc/lighttpd/lighttpd.conf'
    }
    default: { fail("${::operatingsystem} OS not supported.") }
  }
}

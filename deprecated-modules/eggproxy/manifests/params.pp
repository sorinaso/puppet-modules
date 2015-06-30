class eggproxy::params {
case $::operatingsystem {
    'Ubuntu': {
      $dependencies = ['python-pip', 'git-core']
      $cache_directory = '/var/cache/eggproxy'
      $conf_file = '/etc/eggproxy.conf'
      $service_module = 'eggproxy::service::ubuntu'
      $run_script_path = '/usr/local/bin/eggproxy_run'
      $service = 'eggproxy'
    }
    default: { fail("${::operatinsystem} OS not supported.") }
  }
}
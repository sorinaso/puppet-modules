class dnsmasq::params {
  case $::operatingsystem {
    'Ubuntu': {
      $package = 'dnsmasq'
      $service = 'dnsmasq'
      $conf_file = '/etc/dnsmasq.conf'
    }
    default: { fail('OS ${::operatingsystem} not supported.') }
  }
}
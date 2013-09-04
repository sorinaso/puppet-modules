class dnsmasq::conf($source = undef, $content = undef) {
  include dnsmasq::params

  if $source != undef {
    file { $dnsmasq::params::conf_file:
      ensure  =>  $present,
      mode    =>  '644',
      source  =>  $source,
      require =>  Class['dnsmasq'],
    }
  } elsif $content != undef {
    file { $dnsmasq::params::conf_file:
      ensure  =>  present,
      mode    =>  '644',
      content =>  $content,
      require =>  Class['dnsmasq'],
    }
  } else {
    fail("dnsmasq::conf must receive source or content to fill the configuration.")
  }
}
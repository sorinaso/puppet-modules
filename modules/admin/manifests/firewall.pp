class admin::firewall(
$enabled_tcp_ports = undef,
$enabled_udp_ports = undef) {
  resources { "firewall":
    purge => true
  }

  Firewall {
    before  => Class['admin::firewall::post'],
    require => Class['admin::firewall::pre'],
  }

  $firewall_enabled_tcp_ports = is_array($enabled_tcp_ports) ? {
    true  => join($enabled_tcp_ports, ','),
    false => $enabled_tcp_ports,
  }

  $firewall_enabled_udp_ports = is_array($enabled_udp_ports) ? {
    true  => join($enabled_udp_ports, ','),
    false => $enabled_udp_ports,
  }

  if $enabled_tcp_ports {
    firewall { "003 default enabled tcp ports(${firewall_enabled_tcp_ports})":
      port   => $enabled_tcp_ports,
      proto  => tcp,
      action => accept,
    }
  }

  if $enabled_udp_ports {
    firewall { "004 default enabled udp ports(${firewall_enabled_udp_ports})":
      port   => $enabled_udp_ports,
      proto  => udp,
      action => accept,
    }
  }

  class { ['admin::firewall::pre', 'admin::firewall::post']: }

  class { '::firewall': }
}
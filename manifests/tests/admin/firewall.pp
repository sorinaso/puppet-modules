#Firewall {
#  before  => Class['admin::firewall::post'],
#  require => Class['admin::firewall::pre'],
#}
#
#class { ['admin::firewall::pre', 'admin::firewall::post']: }

class { 'admin::firewall':
  enabled_tcp_ports => [22, 80],
  enabled_udp_ports => 53,
}


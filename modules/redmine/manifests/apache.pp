# Soporte de apache para redmine.
class redmine::apache {
  include ::apache

  #Instalamos passenger.
  package { 'libapache2-mod-passenger':
    require => Class[::apache]
  }

  #Optimizacion para passenger.
  file { '/etc/apache2/mods-available/passenger.conf':
    ensure => present,
    source => "puppet:///modules/redmine/passenger.conf",
    owner => 'root',
    group => 'root',
    mode => 644,
    require => Package['libapache2-mod-passenger'],
  }

  apache::module { 'passenger': }
  apache::module { 'rewrite': }

  apache::vhost { 'default':
    file => 'puppet:///modules/redmine/apache_default_vhost',
  }

  Package['libapache2-mod-passenger'] -> Apache::Module['passenger'] -> Apache::Module['rewrite']
}
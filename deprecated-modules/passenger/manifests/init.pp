class passenger {
  package { 'passenger':
    provider => 'gem'
  }
}

class passenger::apache::module($module_path, $passenger_root, $passenger_ruby) {
  # Load and configuration files.
  file { '/etc/apache2/mods-available/passenger.load':
    owner   => "root",
    group   => "root",
    content => inline_template("LoadModule passenger_module <%= module_path %>"),
    require => Package['passenger'],
  }

  file { '/etc/apache2/mods-available/passenger.conf':
    owner   => "root",
    group   => "root",
    content => inline_template("PassengerRoot <%= passenger_root %>
PassengerRuby <%= passenger_ruby %>"),
    require => Package['passenger'],
  }

  # Enabled symlinks.
  file { '/etc/apache2/mods-enabled/passenger.load':
    ensure => 'link',
    target => '/etc/apache2/mods-available/passenger.load',
  }

  file { '/etc/apache2/mods-enabled/passenger.conf':
    ensure => 'link',
    target => '/etc/apache2/mods-available/passenger.conf',
  }
}
class postfix::smtp::relay_map {
  include postfix::params

  file { $postfix::params::smtp_relay_map_path:
    owner => 'root',
    mode  => 400,
  }

  postfix::config::main_cf {
    'sender_dependent_relayhost_maps': ensure => "hash:${postfix::params::smtp_relay_map_path}";
    'smtp_sender_dependent_authentication': ensure => 'yes';
  }
}

class postfix::smtp::relay_map_refresh {
  exec { 'postfix::smtp::relay_map::exec-postmap':
    command     => "/usr/sbin/postmap ${postfix::params::smtp_relay_map_path}",
    refreshonly => true,
  }
}

define postfix::smtp::relay_map_table($ensure)  {
  include postfix::params
  include postfix::smtp::relay_map_refresh

  editfile::config { "postfix::smtp::relay_map_table:${name}":
    path    => $postfix::params::smtp_relay_map_path,
    entry   => $name,
    sep     => "\t",
    ensure  => $ensure,
    require => Class['postfix', 'postfix::smtp::relay_map'],
    notify  => Exec['postfix::smtp::relay_map::exec-postmap'],
  }
}

class postfix::smtp::sasl_passwd_map {
  include postfix::params

  file { $postfix::params::smtp_sasl_passwd_map_path:
    owner => 'root',
    mode  => 400,
  }

  postfix::config::main_cf {
    'smtp_sasl_password_maps': ensure => "hash:${postfix::params::smtp_sasl_passwd_map_path}"
  }
}

class postfix::smtp::sasl_passwd_map_refresh {
  exec { 'postfix::smtp::sasl_passwd_map::exec-postmap':
    command     => "/usr/sbin/postmap ${postfix::params::smtp_sasl_passwd_map_path}",
    refreshonly => true,
  }
}

define postfix::smtp::sasl_passwd_map_table($ensure)  {
  include postfix::params
  include postfix::smtp::sasl_passwd_map_refresh

  editfile::config { "postfix::smtp::sasl_passwd_map_table:${name}":
    path    => $postfix::params::smtp_sasl_passwd_map_path,
    entry   => $name,
    sep     => "\t",
    ensure  => $ensure,
    require => Class['postfix', 'postfix::smtp::sasl_passwd_map'],
    notify  => Exec['postfix::smtp::sasl_passwd_map::exec-postmap'],
  }
}
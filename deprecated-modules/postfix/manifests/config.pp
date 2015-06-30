define postfix::config::main_cf($ensure) {
  include postfix::params

  # main.cf manipulation.
  editfile::config { "postfix::config::main_cf:${name}":
    path    => $postfix::params::main_cf_path,
    entry   => $name,
    sep     => ' = ',
    ensure  => $ensure,
    require => Class['postfix'],
  }
}

class postfix::config::sasl_passwd_map {
  file { $postfix::params::sasl_passwd_map_path:
    owner   => "root",
    mode    => 400,
    require => Class['postfix'],
  }

  postfix::config::main_cf {
    'smtp_sender_dependent_authentication': ensure => "yes";
    'sender_dependent_relayhost_maps':  ensure => "hash:/etc/postfix/sender_relay";
  }
}
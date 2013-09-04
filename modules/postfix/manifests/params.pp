class postfix::params {
  case $osfamily {
    'Debian': {
      $package = 'postfix'
      $service = 'postfix'
      $main_cf_path = '/etc/postfix/main.cf'
      $smtp_sasl_passwd_map_path = "/etc/postfix/sasl_passwd"
      $smtp_relay_map_path = "/etc/postfix/sender_relay"
    }
    default: { fail("osfamily ${osfamily} not implemented") }
  }
}
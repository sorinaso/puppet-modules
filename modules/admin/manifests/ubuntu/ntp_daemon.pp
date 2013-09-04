class admin::ubuntu::ntp_daemon {
  class { ntp:
    ensure     => running,
    enable     => true,
    servers    => ['ntp.ubuntu.com iburst',
                   'pool.ntp.org iburst'],
  }
}
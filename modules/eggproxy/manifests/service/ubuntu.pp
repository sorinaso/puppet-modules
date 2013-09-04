class eggproxy::service::ubuntu($enable) {
  $service_file = "/etc/init.d/${eggproxy::params::service}"

  file { $service_file:
    owner   => 'root',
    mode    => 755,
    content => template("eggproxy/ubuntu.init.d.erb")
  }

  if $enable {
    service { $eggproxy::params::service:
      ensure  => running,
      enable  => true,
      require => File[$service_file]
    }
  }

  Class['eggproxy'] -> Class['eggproxy::service::ubuntu']
}
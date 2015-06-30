define lighttpd::module::activate::ubuntu {
  exec { "/usr/sbin/lighty-enable-mod ${name}":
    user    => 'root',
    unless  => "/bin/ls /etc/lighttpd/conf-enabled|grep '\\-${name}.conf'",
  }
}
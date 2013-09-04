class { 'lighttpd':
  service_enable => true,
  document_root  => '/var/www',
}

lighttpd::module { 'fastcgi': }

package { ['php5-cgi', 'curl']: }

lighttpd::module { 'fastcgi-php':
  require => Package['php5-cgi'],
}

assert::http::status { 'http://localhost':
  code => 200,
}

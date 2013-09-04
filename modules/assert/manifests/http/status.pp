define assert::http::status($code = 200, $ensure = 'succeed') {
  if !defined(Package['curl']) { package{ 'curl': } }

  assert { "${name} returns code ${status_code}":
    ensure    => $ensure,
    logoutput => onfailure,
    command   => "/usr/bin/curl -Is ${name} | head -n 1 | grep ${code}",
    require   => Package['curl'],
  }
}
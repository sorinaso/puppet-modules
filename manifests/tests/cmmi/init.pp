cmmi { 'redis':
  download        => 'http://redis.googlecode.com/files/redis-2.6.13.tar.gz',
  creates         => '/usr/local/bin/redis-server',
  configure_cmd   => false,
}

apt::builddep { 'lynx': }
package { 'libncurses5-dev': }

cmmi { 'lynx':
  download        => 'http://unix-files.com/lynx2.8.7/lynx2.8.7.tar.gz',
  creates         => '/usr/local/bin/lynx',
  pkg_folder      => 'lynx2-8-7',
  require         => [Apt::Builddep['lynx'], Package['libncurses5-dev']],
}

assert { 'must install redis':
  ensure    => 'succeed',
  logoutput => onfailure,
  command   => "test -f /usr/local/bin/redis-server",
  require   => Cmmi['redis'],
}

assert { 'must install lynx':
  ensure    => 'succeed',
  logoutput => onfailure,
  command   => "test -f /usr/local/bin/lynx",
  require   => Cmmi['lynx'],
}
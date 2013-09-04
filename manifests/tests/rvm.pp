rvm::system { '1.9.3':
  ensure  => 'present',
  default => true,
}

rvm::system { '2.0.0':
  ensure  => 'present',
}

rvm::system::gem { '1.9.3/puppet':
  ensure       => 'present',
  version  => '3.0.0',
}

exec { 'must have ruby 1.9.3 and 2.0.0':
  command   => "/bin/bash -l -c 'rvm list'",
  logoutput => true,
  require   => [Rvm::System['1.9.3'], Rvm::System['2.0.0']],
}

exec { 'ruby 1.9.3 must has puppet installed':
  command   => "/bin/bash -l -c 'rvm 1.9.3 do gem list' |grep puppet",
  logoutput => true,
  require   => [Rvm::System::Gem['1.9.3/puppet']],
}

exec { 'ruby 2.0.0 must not has puppet installed':
  command   => "/bin/bash -l -c 'rvm 2.0.0 do gem list' |grep -v puppet",
  logoutput => true,
  require   => [Rvm::System::Gem['1.9.3/puppet']],
}

define rvm::system::gem($ensure = 'present', $version = '') {
  $name_array = split($name, '/')

  $rubyset_version = $name_array[0]
  $gem_name = $name_array[1]

  Exec {
    user => 'root',
    logoutput => on_failure,
  }

  if $version == '' {
    $gem = {
      'install'   => "/bin/bash -l -c 'rvm ${rubyset_version} do gem install ${gem_name} --no-ri --no-rdoc'",
      'uninstall' => "/bin/bash -l -c 'rvm ${rubyset_version} do gem uninstall ${gem_name}'",
      'lookup'    => "/bin/bash -l -c 'rvm ${rubyset_version} do gem list' | grep ${gem_name}",
    }
  } else {
    $gem = {
      'install'   => "/bin/bash -l -c 'rvm ${rubyset_version} do gem install ${gem_name} -v ${version} --no-ri --no-rdoc'",
      'uninstall' => "/bin/bash -l -c 'rvm ${rubyset_version} do gem uninstall ${gem_name} -v ${version}'",
      'lookup'    => "/bin/bash -l -c 'rvm ${rubyset_version} do gem list' | grep ${gem_name} | grep ${version}",
    }
  }

  if $ensure == 'present' {
    exec { "rvm-gem-install-${name}":
      provider  => shell,
      command   => $gem['install'],
      unless    => $gem['lookup'],
      require   => [Rvm::System[$rubyset_version]],
    }
  } elsif $ensure == 'absent' {
    exec { "rvm-gem-uninstall-${name}":
      provider  => shell,
      command   => $gem['uninstall'],
      onlyif    => $gem['lookup'],
      require   => [Rvm::System[$rubyset_version]],
    }
  }
}
define rvm::system(
  $ensure = 'present',
  $default = false,
) {
  include rvm

  Exec {
    user => 'root',
  }

  if $ensure == 'present' {
    exec { "install-ruby-${name}":
      provider  => shell,
      command => "/bin/bash -l -c 'rvm install ${name}'",
      unless  => "/bin/bash -l -c 'rvm list' | grep ${name}",
      timeout => '0',
      logoutput => on_failure,
      require => Class['rvm'],
    }
    if $default {
      exec { "rvm-set-default-${name}":
        provider  => shell,
        command   => "/bin/bash -l -c 'rvm use ${name} --default'",
        unless    => "/bin/bash -l -c 'rvm list' | grep ${name} | grep '*'",
        require   => Exec["install-ruby-${name}"],
      }
    }
  } elsif $ensure == 'absent' {
    exec { "uninstall-ruby-${name}":
      provider  => shell,
      command => "/bin/bash -l -c 'rvm uninstall ${name}'",
      onlyif  => "/bin/bash -l -c 'rvm list' | grep ${name}",
      logoutput => on_failure,
      require => Class['rvm'],
    }
  }

  # Establish Default System Ruby.
  # Only create one instance to prevent multiple ruby
  # versions from attempting to be system default.
#  if ($system == 'true') and ($ensure != 'absent') {
#    exec { "set-default-ruby-rvm-to-${name}":
#      command => "/usr/local/bin/rvm_set_system_ruby ${name}",
#      unless  => "rvm list | grep '* ${name}'",
#      require => [Class['rvm'], Exec["install-ruby-${name}"]],
#      notify  => Exec['rvm-cleanup'],
#    }
#  }
}


class red5($version, $target="/usr/share", $enable=false) {
  include wget

  case $version {
    "1.0.0": {
      $red5_url = 'http://red5.org/downloads/red5/1_0/red5-1.0.0.tar.gz'
      $red5_downloaded_file = "${target}/red5-1.0.0.tar.gz"
      $home = "${target}/red5-1.0.0-build-jenkins-red5-226"
    }
  }

  $red5_start_script = "${home}/red5.sh"
  $red5_shutdown_script = "${home}/red5-shutdown.sh"

  # Java dependencies.
  package { ['default-jdk', 'default-jre']: }

  # fetch from site.
  wget::fetch { 'red5-fetch':
    source      => $red5_url,
    destination => $red5_downloaded_file,
    timeout     => 0,
    verbose     => true,
    notify      => Exec['red5-uncompress'],
  }

  # uncompress red5.
  exec { 'red5-uncompress':
    command     => "/bin/tar xvfz ${$red5_downloaded_file}",
    cwd         => $target,
    creates     => $home,
    refreshonly => true,
  }

  # Executables.
  fs::chmod { $red5_start_script:
    mode => 744,
    require => Exec['red5-uncompress'],
  }

  fs::chmod { $red5_shutdown_script:
    mode => 744,
    require => Exec['red5-uncompress'],
  }

  # /etc/init.d/red5
  file { '/etc/init.d/red5':
    owner     => root,
    mode      => 744,
    content   => template("red5/initd.erb"),
    ensure    => present,
    require   => Fs::Chmod[$red5_start_script, $red5_shutdown_script],
  }

  # Service enabled?
  service { 'red5':
    enable  => $enable,
    require => File['/etc/init.d/red5'],
  }
}
define cmmi (
$download = undef,
$source = undef,
$creates,
$logoutput = on_failure,
$pkg_folder ='',
$pkg_format = "tar",
$pkg_extension = "",
$configure_cmd = "configure",
$extractorcmd = "",
$make_cmd = "/usr/bin/make && /usr/bin/make install",
$rm_build_folder = true) {
  include cmmi::params
  include cmmi::dependencies

  if $download == undef and $source == undef {
    fail("Must give download url or source")
  }

  if $download and $source {
    fail("Can't give download url and source")
  }

  $cwd = "/usr/local/src"

  Exec {
    unless    => "${cmmi::params::test_cmd} -f $creates",
    user      => 'root',
    logoutput => $logoutput,
    timeout   => 900,
  }

  if $download {
    $filename = basename($download)

    # download source
    exec { "cmmi-download-${name}":
      cwd     => $cwd,
      command => "${cmmi::params::wget_cmd} -q ${download}",
      timeout => 120, # 2 minutes
    }
  }

  if $source {
    $filename = basename($source)

    # download source
    file { "${cwd}/${filename}":
      source  => $source,
      owner   => 'root',
      group   => 'root',
    }
  }


  $extension = $pkg_format ? {
    zip     => ".zip",
    bzip    => ".tar.bz2",
    tar     => ".tar.gz",
    default => $pkg_extension,
  }

  $foldername = $pkg_folder ? {
    ''      => gsub($filename, $extension, ""),
    default => $pkg_folder,
  }

  $src_path  = "${cwd}/${foldername}"

  $extractor = $pkg_format ? {
    zip     => "${cmmi::params::unzip_cmd} -q -d ${cwd} ${cwd}/${filename}",
    bzip    => "${cmmi::params::bunzip_cmd} -c ${cwd}/${filename} | ${cmmi::params::tar_cmd} -xf -",
    tar     => "${cmmi::params::gunzip_cmd} < ${cwd}/${filename} | ${cmmi::params::tar_cmd} -xf -",
    default => $extractorcmd,
  }

  # extract source
  exec { "cmmi-extract-${name}":
    cwd     => $cwd,
    command => $extractor,
    timeout => 120, # 2 minutes
    require => $download ? {
      undef   => File["${cwd}/${filename}"],
      default => Exec["cmmi-download-${name}"],
    }
  }

  # configure
  if $configure_cmd != false {
    exec { "cmmi-config-${name}":
      cwd     => $src_path,
      command => "${src_path}/${configure_cmd}",
      timeout => 120, # 2 minutes
      require => Exec["cmmi-extract-${name}"],
    }
  }

  # compile and install
  exec { "cmmi-make-install-${name}":
    cwd     => $src_path,
    command => "${make_cmd}",
    timeout => 600, # 10 minutes
    require => $configure_cmd ? {
      false   => Exec["cmmi-extract-${name}"],
      default => Exec["cmmi-config-${name}"]
    },
  }

  # remove build folder
  if $rm_build_folder == true {
    exec { "remove-${name}-build-folder":
      cwd     => $cwd,
      command => "${cmmi::params::rm_cmd} -rf ${src_path}",
      require =>  Exec["cmmi-make-install-${name}"],
    }
  }
}

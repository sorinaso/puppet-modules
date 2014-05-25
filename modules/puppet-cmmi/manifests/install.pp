define cmmi::install (
$source,
$target_src_directory,
$target_src_filename,
$target_src_directoryname,
$configure_cmd = "configure",
$make_cmd = "/usr/bin/make && /usr/bin/make install"
$rm_build_folder = true) {
include cmmi::params
include cmmi::dependencies
  $compilation_directory = dirname($target_directory)

  cmmi::download { $source:
    directory => $compilation_directory,
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


$src_path  = "${cwd}/${foldername}"

cmmi::extract { $src_path:
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

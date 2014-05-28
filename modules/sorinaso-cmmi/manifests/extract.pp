define cmmi::extract(
$creates
) {
  $filename = $name

  $extension = $pkg_format ? {
    zip     => ".zip",
    bzip    => ".tar.bz2",
    tar     => ".tar.gz",
    default => $pkg_extension,
  }

  $extractor = $pkg_format ? {
    zip     => "${cmmi::params::unzip_cmd} -q -d ${cwd} ${cwd}/${filename}",
    bzip    => "${cmmi::params::bunzip_cmd} -c ${cwd}/${filename} | ${cmmi::params::tar_cmd} -xf -",
    tar     => "${cmmi::params::gunzip_cmd} < ${cwd}/${filename} | ${cmmi::params::tar_cmd} -xf -",
    default => $extractorcmd,
  }

  exec { "cmmi-extract-${name}":
    cwd     => $cwd,
    command => $extractor,
    timeout => 120, # 2 minutes
    unless    => "${cmmi::params::test_cmd} -f ${creates}",
    require => $download ? {
    undef   => File["${cwd}/${filename}"],
    default => Exec["cmmi-download-${name}"],
    }
  }
}
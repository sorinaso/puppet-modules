define cmmi::extract(
$extension,
$command = undef,
$user,
$creates,
$timeout = 120
) {
  $file = $name
  $directory = dirname($file)
  $filename = basename($file)

  # Command for extraction.
  $extractor = $extension ? {
    '.tar.bz2'    => "${cmmi::bunzip_cmd} -c ${file} | ${cmmi::tar_cmd} -xf -",
    '.tar.gz'     => "${cmmi::gunzip_cmd} < ${file} | ${cmmi::tar_cmd} -xf -",
    default => $command,
  }

  # Extract source.
  exec { "cmmi-extract-${file}":
    cwd     => $directory,
    command => $extractor,
    creates => $creates,
    timeout => $timeout,
  }

  Cmmi::Extract[$name] -> Class['cmmi']
}
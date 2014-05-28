# == Class: example_class
#
# Extract the source code for compilation given an extension(tar.gz or tar.bz2)
# or a custom command.
#
# === Parameters
#
# [*file*]
# File to extract.
#
# [*extension*]
# Compression extension(.tar.gz and .tar.bz2 supported).
#
# [*command*]
# Specific extract command.
#
# [*user*]
# User that run commands.
#
# [*creates*]
# Directory or file that extraction create(for idempotency)
#
# [*timeout*]
# Command timeout.
#
# Document parameters here.
#
# === Variables
#
# === Examples
#
# === Authors
#
# Alejandro Souto <sorinaso@gmail.com>
#
define cmmi::extract(
$file,
$extension = undef,
$command = undef,
$user,
$creates,
$timeout,
) {
  $directory = dirname($file)
  $filename = basename($file)

  if ($extension == undef and $command == undef) or
     ($extension != undef and $command != undef)
  {
    fail("Must define extension or command.")
  }

  # Command for extraction.
  if $command {
    $extractor = $command
  } else {
    case $extension {
      '.tar.bz2': { $extractor = "${cmmi::bunzip_cmd} -c ${file} | ${cmmi::tar_cmd} -xf -" }
      '.tar.gz': { $extractor = "${cmmi::gunzip_cmd} < ${file} | ${cmmi::tar_cmd} -xf -" }
      default: { fail("Unsupported extension '${extension}'.") }
    }
  }

  # Extract source.
  exec { "cmmi-extract-${name}":
    cwd       => $directory,
    command   => $extractor,
    creates   => $creates,
    timeout   => $timeout,
    logoutput => on_failure,
  }

  Cmmi::Extract[$name] -> Class['cmmi']
}
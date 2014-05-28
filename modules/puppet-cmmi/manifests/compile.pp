# == Define Resource Type: cmmi::compile
#
# Compilation for cmmi given e source directory.
#
# === Parameters
#
# [*directory*]
# Source directory.
#
# [*creates*]
# Binary that compilation creates for idempotency.
#
# [*configure_cmd*]
# Configure command for compilation.
#
# [*make_cmd*]
# Make command for compilation.
#
# [*timeout*]
# Timeout for commands.
#
# [*rm_source_folder*]
# Remove build folder after compile?
#
# === Variables
#
# === Examples
#
# === Authors
#
# Alejandro Souto <sorinaso@gmail.com>
#

define cmmi::compile (
$directory,
$creates,
$user,
$configure_cmd,
$make_cmd,
$timeout,
$rm_source_folder = true) {
  # Default paramaters for Exec
  Exec {
    timeout => $timeout,
    user    => $user,
  }

  # Configure
  if $configure_cmd != false {
    exec { "cmmi-compile-${name}-config":
      command => $configure_cmd,
      cwd     => $directory,
      unless  => "/usr/bin/test -f ${creates}",
    }
  }

  # compile and install
  exec { "cmmi-compile-${name}-make-install":
    command => "${make_cmd}",
    cwd     => $directory,
    unless  => "/usr/bin/test -f ${creates}",
    require => $configure_cmd ? {
      false   => undef,
      default => Exec["cmmi-compile-${name}-config"],
    }
  }

  # Remove build folder
  if $rm_source_folder {
    exec { "cmmi-compile-${name}-rm-build-folder":
      command => "${cmmi::rm_cmd} -rf ${directory}",
      require =>  Exec["cmmi-compile-${name}-make-install"],
      onlyif  => "/usr/bin/test -d ${directory}",
    }
  }

  Cmmi::Compile[$name] -> Class['cmmi']
}

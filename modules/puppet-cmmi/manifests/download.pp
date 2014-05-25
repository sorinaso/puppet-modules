# == Class: example_class
#
# Download a source for installation.
#
# === Parameters
#
# [*directory*]
# Directory where this module download de file.
#
# [*user*]
# User which runs wget.
#
# [*creates*]
# File that downloads for idempotency.
#
# [*timeout*]
# Timeout for download.
#
# === Variables
#
# === Examples
#
# === Authors
#
# Alejandro Souto <sorinaso@gmail.com>
#

define cmmi::download(
$directory,
$creates,
$user = 'root',
$timeout = 120,
) {
  $url = $name

  # download source
  exec { "cmmi-download-wget-${name}":
    cwd       => $directory,
    command   => "${cmmi::wget_cmd} -q ${url}",
    creates   => $creates,
    timeout   => $timeout,
    user      => $user,
  }

  Cmmi::Download[$name] -> Class['cmmi']
}
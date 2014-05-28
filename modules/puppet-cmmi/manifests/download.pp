# == Define Resource Type: cmmi::download
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
$url,
$directory,
$creates,
$user,
$timeout
) {
  # download source
  exec { "cmmi-download-${name}-wget":
    cwd       => $directory,
    command   => "${cmmi::wget_cmd} -q ${url}",
    creates   => $creates,
    timeout   => $timeout,
    user      => $user,
  }

  Cmmi::Download[$name] -> Class['cmmi']
}
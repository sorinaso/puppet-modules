# == Define Resource Type: cmmi::install
#
# Download a source from an url, extract, compile and install.
#
# === Parameters
#
# [*user*]
# User for preform all operations.
#
# [*download_url*]
# URL where the source is located in the internet.
#
# [*download_filename*]
# Filename of download(example: for www.lala.com/lala.tar.gz is lala.tar.gz)
#
# [*download_timeout*]
# Timeout for download.

# [*extract_timeout*]
# Timeout for extraction.
#
# [*extract_extension*]
# Extension of compressed source(tar.gz or tar.bz2)
#
# [*compilation_timeout*]
# Timeout for compilation.
#
# [*compilation_directory*]
# Base directory for compilation(example: /usr/local/src)
#
# [*compilation_configure_cmd*]
# Configure command for compilation.
#
# [*compilation_make_cmd*]
# Make, make install, etc. commands for compilation
#
# [*compilation_source_folder_name*]
# Folder name of source extracted(example: iproute2-3.2.0)
#
# [*compilation_creates*]
# File product of compilation(for idenpotency)
#
# [*compilation_rm_source_folder*]
# Must delete source folder after compilation?
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

define cmmi::install(
$user = 'root',
$download_url,
$download_filename,
$download_timeout = 600,
$extract_timeout = 600,
$extract_extension,
$compilation_timeout = 600,
$compilation_directory = '/usr/local/src',
$compilation_configure_cmd,
$compilation_make_cmd = "/usr/bin/make && /usr/bin/make install",
$compilation_source_folder_name,
$compilation_creates,
$compilation_rm_source_folder = true) {
  $download_directory = $compilation_directory
  $download_file_path = "${download_directory}/${download_filename}"

  $compilation_source_path = "${compilation_directory}/${compilation_source_folder_name}"

  $extract_file_path = $download_file_path
  $extract_target_directory = $compilation_source_path

  cmmi::download { $name:
    url       => $download_url,
    user      => $user,
    directory => $download_directory,
    creates   => $download_file_path,
    timeout   => $download_timeout,
  } ->

  cmmi::extract { $name:
    file      => $extract_file_path,
    user      => $user,
    extension => $extract_extension,
    creates   => $extract_target_directory,
    timeout   => $extract_timeout,
  } ->

  cmmi::compile { $name:
    directory         => $compilation_source_path,
    user              => $user,
    creates           => $compilation_creates,
    make_cmd          => $compilation_make_cmd,
    configure_cmd     => $compilation_configure_cmd,
    rm_source_folder  => $compilation_rm_source_folder,
    timeout           => $compilation_timeout,
  }
}

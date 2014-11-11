class zabbix::install {
  # Paths for database and frontends..
  $src_database_path = "${zabbix::compilation_src_path}/database"
  $src_frontends_path = "${zabbix::compilation_src_path}/frontends"
  $share_database_path = "${zabbix::share_path}/database"
  $share_frontends_path = "${zabbix::share_path}/frontends"

  # Copy commands.
  $copy_database_path = "/bin/cp -r ${src_database_path} ${zabbix::share_path}/"
  $copy_frontends_path = "/bin/cp -r ${src_frontends_path} ${zabbix::share_path}/"

  # Compile zabbix
  include cmmi

  # Dependencies.
  package { $zabbix::compilation_required_packages: } ->

  # Installation from source.
  cmmi::install { 'zabbix':
    download_url                   => $zabbix::source_url,
    download_filename              => $zabbix::source_filename,
    extract_extension              => $zabbix::extract_extension,
    compilation_directory          => $zabbix::compilation_directory,
    compilation_configure_cmd      => $zabbix::compilation_configure_cmd,
    compilation_make_cmd           => $zabbix::compilation_make_cmd,
    compilation_source_folder_name => $zabbix::compilation_source_folder_name,
    compilation_creates            => $zabbix::compilation_creates,
    compilation_rm_source_folder   => $zabbix::compilation_rm_source_folder,
  } ->

  # Copy zabbix database path to share directory.
  exec { $copy_database_path:
    creates => $share_database_path,
  } ->

  # Copy zabbix frontend path to share directory.
  exec { $copy_frontends_path:
    creates => $share_frontends_path,
  } ->

  # Create zabbix group.
  group { $zabbix::group:
    ensure => present,
  } ->

  # Create zabbix user.
  user { $zabbix::user:
    gid     => $zabbix::user,
    ensure  => present,
  } ->

  # Path for logs.
  file { $zabbix::log_path:
    ensure  => directory,
    owner   => $zabbix::user,
    group   => $zabbix::group,
    require => [User[$zabbix::user], Group[$zabbix::group]],
  }
}
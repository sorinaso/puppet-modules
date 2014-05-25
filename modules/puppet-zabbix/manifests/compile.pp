class zabbix::compile(
$source,
$src_folder,
$compilation_required_packages = $zabbix::params::compilation_required_packages,
$mysql_required_packages = $zabbix::params::mysql_required_packages,
$enable_server = false,
$enable_agent = false,
$enable_mysql = false
) inherits zabbix::params {
  # Souce relative paths.
  $src_database_path = "${src_path}/database"
  $src_frontends_path = "${src_path}/frontends"

  # Copy commands.
  $copy_database_path = "/bin/cp -r ${src_database_path} ${share_path}/"
  $copy_frontends_path = "/bin/cp -r ${src_frontends_path} ${share_path}/"

  # Enable server in zabbix compilation.
  $enable_server_flag = $enable_server ? {
    true    => ' --enable-server',
    default => '',
  }

  # Enable agent in zabbix compilation.
  $enable_agent_flag = $enable_agent ? {
    true    => ' --enable-agent',
    default => '',
  }

  # Enable MySQL in zabbix compilation.
  $enable_mysql_flag = $enable_mysql ? {
    true    => ' --enable-mysql',
    default => '',
  }

  # Dependencias de mysql.
  if $enable_mysql { package { $mysql_required_packages: } }

  # Configure command for compilation.
  $configure_cmd = "${cmmi::src_path}/bootstrap.sh && ${cmmi::src_path}/configure${enable_server_flag}${enable_agent_flag}${enable_mysql_flag}"

  package { $compilation_required_packages: } ->

  cmmi { 'zabbix':
    download        => $source,
    #source          => $source_module_file,
    creates         => $zabbix::params::server_bin,
    configure_cmd   => $configure_cmd,
    pkg_folder      => $src_folder,
    rm_build_folder => false,
  } ->

  exec { $copy_database_path:
    creates => $share_database_path,
  } ->

  exec { $copy_frontends_path:
    creates => $share_frontends_path,
  } ->

  exec { "/bin/rm -r ${src_path}":
    onlyif  => "/usr/bin/test -d ${src_path}",
  } ->

  group { 'zabbix':
    ensure => present,
  } ->

  user { 'zabbix':
    gid     => 'zabbix',
    ensure  => present,
  } ->

  file { $log_path:
    ensure  => directory,
    owner   => 'zabbix',
    group   => 'zabbix',
    require => [User['zabbix'], Group['zabbix']],
  }
}
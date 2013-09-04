class supervisor(
  $ensure                   = 'present',
  $autoupgrade              = false,
  $service_ensure           = 'running',
  $service_enable           = true,
  $enable_inet_server       = false,
  $inet_server_port         = '*:9000',
  $inet_server_user         = undef,
  $inet_server_pass         = undef,
  $logfile                  = '/var/log/supervisor/supervisord.log',
  $logfile_maxbytes         = '500MB',
  $logfile_backups          = 10,
  $log_level                = 'info',
  $minfds                   = 1024,
  $minprocs                 = 200,
  $childlogdir              = '/var/log/supervisor',
  $nocleanup                = false,
  $user                     = undef,
  $umask                    = '022',
  $supervisor_environment   = undef,
  $identifier               = undef,
  $recurse_config_dir       = false,
  $logrotate_periodicity    = 'daily'
) inherits supervisor::params {

  #include supervisor::update

  case $ensure {
    present: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      case $service_ensure {
        running, stopped: {
          $service_ensure_real = $service_ensure
        }
        default: {
          fail('service_ensure parameter must be running or stopped')
        }
      }

      $dir_ensure = 'directory'
      $file_ensure = 'file'
    }
    absent: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $dir_ensure = 'absent'
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  if ! defined(Package[$supervisor::params::package]) {
    package { $supervisor::params::package:
      ensure => $package_ensure,
    }
  }

  file { $supervisor::params::conf_dir:
    ensure  => $dir_ensure,
    purge   => true,
    recurse => $recurse_config_dir,
    require => Package[$supervisor::params::package],
  }

  file { [
    '/var/log/supervisor',
    '/var/run/supervisor'
  ]:
    ensure  => $dir_ensure,
    purge   => true,
    backup  => false,
    require => Package[$supervisor::params::package],
  }

  file { $supervisor::params::conf_file:
    ensure  => $file_ensure,
    content => template('supervisor/supervisord.conf.erb'),
    require => File[$supervisor::params::conf_dir],
    notify  => Service[$supervisor::params::system_service],
  }

  file { '/etc/logrotate.d/supervisor':
    ensure  => $file_ensure,
    content   => template('supervisor/logrotate.erb'),
    require => Package[$supervisor::params::package],
  }

  service { $supervisor::params::system_service:
    ensure     => $service_ensure_real,
    enable     => $service_enable,
    hasrestart => true,
    require    => File[$supervisor::params::conf_file],
  }
}

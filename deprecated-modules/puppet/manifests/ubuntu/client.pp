class puppet::ubuntu::client($ensure = latest) {
#
#  $puppet_var_directory = "${puppet_directory}/var"
#  $puppet_run_directory = "${puppet_var_directory}/run"
#  $puppet_log_directory = "${puppet_var_directory}/log"
#  $puppet_extra_directories = [$puppet_directory, $puppet_var_directory,
#  $puppet_run_directory, $puppet_log_directory]
#
#  file { $puppet_extra_directories:
#    ensure  => directory,
#    require => Class[puppet],
#  }
#
#  # Configurcion de puppet.
#  file { "$puppet_directory/puppet.conf":
#    content => template('puppet/client.puppet.conf.erb'),
#    mode    => 664,
#    require => File[$puppet_extra_directories],
#  }
  include puppet::ubuntu::repo

  # We install the package.
  package { 'puppet':
    ensure  => $ensure,
    require => Class['puppet::ubuntu::repo'],
  }
}
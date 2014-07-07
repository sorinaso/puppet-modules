class zabbix(
$version = '2.2.3',
) inherits zabbix::params {
  case $version {
    '2.2.3': {
      $source_url = "http://ufpr.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/${version}/zabbix-${version}.tar.gz"
      $source_filename = "zabbix-${version}.tar.gz"
      $extract_extension = '.tar.gz'
      $compilation_directory = '/usr/local/src'
      $compilation_source_folder_name = "zabbix-${version}"
      $compilation_make_cmd = "/usr/bin/make && /usr/bin/make install"
      $compilation_creates = '/usr/local/sbin/zabbix_server'
      $compilation_src_path = "${compilation_directory}/${compilation_source_folder_name}"
      $compilation_configure_cmd = "${compilation_src_path}/configure --enable-server --enable-agent --with-mysql"
      $compilation_rm_source_folder = false
      $compilation_required_packages = $mysql_required_packages
    }
  }
  case $::operatingsystem {
    'Ubuntu': {
      # Server
      $server_service_name = 'zabbix-server'
      $server_service_file = "/etc/init.d/zabbix-server"
      $server_service_template = "zabbix/server/ubuntu.init_d.erb"

      # Agent.
      $agent_service_name = 'zabbix-agent'
      $agent_service_file = "/etc/init.d/zabbix-agent"
      $agent_service_template = "zabbix/agent/ubuntu.init_d.erb"

    }
  }

  include zabbix::install
}
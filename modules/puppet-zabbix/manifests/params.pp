class zabbix::params {
  case $::operatingsystem {
  'Ubuntu': {
    # User and group.
    $user = 'zabbix'
    $group = 'zabbix'

    # Dependencies.
    $compilation_required_packages = ['automake']
    $mysql_required_packages = ['libmysqlclient-dev']

    # OS paths.
    $sbin_path = '/usr/local/sbin'
    $etc_path = '/usr/local/etc'
    $php_cgi_ini_file = '/etc/php5/cgi/php.ini'
    $log_path = '/var/log/zabbix'
    $www_dir  = ''

    # Share paths.
    $share_path = '/usr/local/share/zabbix'

    $share_frontends_path = "${share_path}/frontends"
    $share_php_frontend_path = "${$share_frontends_path}/php"

    $share_database_path = "${share_path}/database"
    $share_mysql_path = "${share_database_path}/mysql"

    # Agent.
    $agent_bin  = "${sbin_path}/zabbix_agent"
    $agent_service_name = 'zabbix-agent'
    $agent_service_file = "/etc/init.d/zabbix-agent"
    $agent_service_template = "zabbix/agent/ubuntu.init_d.erb"
    $agent_conf_file  = "${etc_path}/zabbix_agent.conf"

    # Agentd
    $agentd_bin = "${sbin_path}/zabbix_agentd"
    $agentd_conf_file = "${etc_path}/zabbix_agentd.conf"

    # Server.
    $server_bin = "${sbin_path}/zabbix_server"
    $server_service_name = 'zabbix-server'
    $server_service_file = "/etc/init.d/zabbix-server"
    $server_service_template = "zabbix/server/ubuntu.init_d.erb"
    $server_conf_file  = "${etc_path}/zabbix_server.conf"
    $server_log_file = "${log_path}/zabbix_server.log"

    # Mysql server.
    $mysql_server_required_packages = ['mysql-client']

    # PHP Frontend paths.
    $php_frontend_zabbix_conf_file = "${share_php_frontend_path}/conf/zabbix.conf.php"
    $php_frontend_zabbix_conf_file_template = "zabbix/frontends/php/zabbix.conf.php.erb"
  }
  default: { fail("${::operatingsystem} OS not supported.") }
  }
}
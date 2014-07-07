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
    $php_ini_apache_path = '/etc/php5/apache2/php.ini'
    $php_ini_cgi_path = '/etc/php5/cgi/php.ini'
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
    $agentd_bin = "${sbin_path}/zabbix_agentd"
    $agent_conf_file  = "${etc_path}/zabbix_agent.conf"
    $agentd_conf_file = "${etc_path}/zabbix_agentd.conf"

    # Server.
    $server_bin = "${sbin_path}/zabbix_server"
    $server_conf_file  = "${etc_path}/zabbix_server.conf"
    $server_log_file = "${log_path}/zabbix_server.log"

    # Mysql server.
    $mysql_server_required_packages = ['mysql-client']

    # PHP Frontend paths.
    $php_frontend_apache_conf_file = '/etc/apache2/conf.d/zabbix.conf'
    $php_frontend_apache_conf_file_template = "zabbix/frontends/php/apache.conf.erb"
    $php_frontend_lighttpd_conf_file = '/etc/lighttpd/lighttpd.conf'
    $php_frontend_zabbix_conf_file = "${share_php_frontend_path}/conf/zabbix.conf.php"
    $php_frontend_zabbix_conf_file_template = "zabbix/frontends/php/zabbix.conf.php.erb"
    $php_frontend_required_packages = ['apache2', 'php5', 'php5-gd', 'php5-mysql' ]
  }
  default: { fail("${::operatingsystem} OS not supported.") }
  }
}
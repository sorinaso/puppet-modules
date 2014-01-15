class zabbix::params {
  case $::operatingsystem {
  'Ubuntu': {
    $source_url = 'http://tenet.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.0.6/zabbix-2.0.6.tar.gz'
    $source_module_file = 'puppet:///modules/zabbix/source/zabbix-2.0.6.tar.gz'

    $required_packages = ['libmysqlclient-dev']

    # Source relative paths.
    $src_path = '/usr/local/src/zabbix-2.0.6'
    $src_database_path = "${src_path}/database"
    $src_frontends_path = "${src_path}/frontends"

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
    $agent_service_module = 'zabbix::agent::service::ubuntu'
    $agent_conf_file  = "${etc_path}/zabbix_agent.conf"
    $agent_conf_file_template = "zabbix/agent/zabbix_agent.conf.erb"
    $agentd_conf_file = "${etc_path}/zabbix_agentd.conf"
    $agentd_conf_file_template = "zabbix/agent/zabbix_agentd.conf.erb"

    # Server.
    $server_bin = "${sbin_path}/zabbix_server"
    $server_conf_file  = "${etc_path}/zabbix_server.conf"
    $server_service_module = 'zabbix::server::service::ubuntu'
    $server_log_file = "${log_path}/zabbix_server.log"

    # PHP Frontend paths.
    $php_frontend_apache_conf_file = '/etc/apache2/conf.d/zabbix.conf'
    $php_frontend_apache_conf_file_template = "zabbix/frontends/php/apache.conf.erb"
    $php_frontend_lighttpd_conf_file = '/etc/lighttpd/lighttpd.conf'
    $php_frontend_zabbix_conf_file = "${share_php_frontend_path}/conf/zabbix.conf.php"
    $php_frontend_zabbix_conf_file_template = "zabbix/frontends/php/zabbix.conf.php.erb"
    $php_frontend_apache_required_packages = ['apache2', 'php5', 'php5-gd', 'php5-mysql' ]

    # Lighttpd.
    $php_frontend_lighttpd_required_packages = ['php5-cgi', 'php5-gd', 'php5-mysql']
    $php_frontend_lighttpd_required_modules = $::lsbdistrelease ? {
      '10.04' => 'fastcgi',
      default => ['fastcgi', 'fastcgi-php'],
    }

    #$php_frontend_lighttpd_required_modules = ['fastcgi', 'fastcgi-php']
    $php_frontend_lighttpd_document_root = '/var/www'

    # Apache.
    $php_frontend_apache_service = 'apache2'
  }

  default: { fail("${::operatingsystem} OS not supported.") }
  }
}
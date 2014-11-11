require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper_acceptance', 'spec_helper_acceptance'))

beaker_configuration('puppet-zabbix') do |c|
  beaker_install_local_module('puppet-cmmi')
  beaker_install_local_module('puppet-common') if beaker_is_provisioning?
  beaker_install_module('puppetlabs/stdlib') if beaker_is_provisioning?
  beaker_install_module('puppetlabs/mysql') if beaker_is_provisioning?
  beaker_install_module('puppetlabs/apache') if beaker_is_provisioning?
end

module SpecHelper
  module Utils
    def self.restore_conf_file(filename)
      find_cmd = "find /usr/local/src -name '#{filename}'"
      check_cmd = "#{find_cmd}|egrep #{filename}"
      echo_no_conf_cmd = "echo '#{filename} doesnt exists'"
      copy_cmd = "#{find_cmd} -exec cp '{}' /usr/local/etc/ \\;"

      "((#{check_cmd}) && (#{copy_cmd})) || (#{echo_no_conf_cmd})"
    end
  end
  module Install
    def binaries
      [
        "/usr/local/sbin/zabbix_agentd",
        "/usr/local/sbin/zabbix_server",
        "/usr/local/sbin/zabbix_agent",
        "/usr/local/bin/zabbix_sender",
        "/usr/local/bin/zabbix_get"
      ]
    end

    def binaries_user
      "root"
    end

    def binaries_group
      "root"
    end

    def clean_cmd
      "rm -rf /usr/local/*/*"
    end
  end

  module Server
    module Service
      def self.name; 'zabbix-server' end

      def self.script_path; "/etc/init.d/#{name}" end

      def self.script_user; "root" end

      def self.script_group; "root" end

      def self.script_mode; "root" end

      def self.clean_cmd
        "rm -rf #{script_path}"
      end
    end

    module Config
      def self.clean_cmd
        "(#{SpecHelper::Utils.restore_conf_file('zabbix_server.conf')}) ; (rm -rf #{log_file})"
      end

      def self.conf_file; "/usr/local/etc/zabbix_server.conf" end

      def self.log_file; "/var/log/zabbix_server_test.log" end

      def self.log_file_user; "zabbix" end

      def self.log_file_group; "zabbix" end
    end

    module MYSQL
      def self.clean_cmd; "echo 'drop database #{database}' | mysql -u #{username} -p#{password}" end

      def self.database; "zabbix_test" end

      def self.username; "zabbix_test" end

      def self.password; "zabbix_test" end

      def self.check_database_cmd;
        "echo 'show databases' | mysql -u #{username} -p#{password} |egrep #{database}"
      end

      def self.check_database_table_cmd(table)
          "/bin/echo 'show tables' | /usr/bin/mysql -u #{username} -p#{password} #{database}|/bin/egrep #{table}"
      end

      def self.check_table_not_empty_cmd(table)
        "/bin/echo 'select count(*) from #{table}' | /usr/bin/mysql -u #{username} -p#{password} #{database} | /bin/egrep -v '0$'"
      end

      def self.check_schema_migrated_cmd; check_database_table_cmd("users") end

      def self.check_data_migrated_cmd; check_table_not_empty_cmd("users") end

      def self.check_images_migrated_cmd; check_table_not_empty_cmd("images") end

      def self.mysql_pp
        <<-EOS
          class { 'mysql::server': } ->

          mysql::db { '#{SpecHelper::Server::MYSQL.database}':
             user     => '#{SpecHelper::Server::MYSQL.username}',
             password => '#{SpecHelper::Server::MYSQL.password}',
          }
        EOS
      end
      def self.zabbix_pp(opts = {})
        opts = { :service_ensure => 'running', :service_enable => 'true' }.merge(opts)

        <<-EOS
        #{mysql_pp}

        class { 'zabbix': } ->

        class { 'zabbix::server':
          service_enable    => #{opts[:service_enable]},
          service_ensure    => #{opts[:service_ensure]},
          database_provider => 'mysql',
          database_name     => '#{SpecHelper::Server::MYSQL.database}',
          database_user     => '#{SpecHelper::Server::MYSQL.username}',
          database_password => '#{SpecHelper::Server::MYSQL.password}',
        }
        EOS
      end
    end
  end

  module Agent
    module Service
      def self.name; 'zabbix-agent' end

      def self.script_path; "/etc/init.d/#{name}" end

      def self.script_user; "root" end

      def self.script_group; "root" end

      def self.script_mode; "root" end

      def self.clean_cmd
        "rm -rf #{script_path}"
      end
    end

    module Config
      def self.clean_cmd
        rm_log_file_cmd = "rm -rf #{log_file}"
        restore_agent_cmd = SpecHelper::Utils.restore_conf_file('zabbix_agent.conf')
        restore_agentd_cmd = SpecHelper::Utils.restore_conf_file('zabbix_agentd.conf')

        "#{restore_agent_cmd} ; #{restore_agentd_cmd} ; #{rm_log_file_cmd}"
      end

      def self.agent_conf_file; "/usr/local/etc/zabbix_agent.conf" end

      def self.agentd_conf_file; "/usr/local/etc/zabbix_agentd.conf" end

      def self.log_file; "/var/log/zabbix_agentd_test.log" end

      def self.log_file_user; "zabbix" end

      def self.log_file_group; "zabbix" end

      def self.server_ip; "192.168.0.1" end
    end
  end

  module Frontend
    module PHP
      module Config
        def self.clean_cmd
          rm_frontend_conf_cmd = "rm -f #{zabbix_frontend_conf_file}"
          uninstall_php_cmd = "((dpkg -l | grep #{php_package_name}) && (sudo apt-get -q -y purge #{php_package_name})) ; /bin/true"

          return "(#{rm_frontend_conf_cmd}) ; (#{uninstall_php_cmd})"
        end

        def self.install_php_cmd; "apt-get -q -y install #{php_package_name}" end

        def self.php_package_name; "php5-cli" end

        def self.database_hostname; 'localhost' end

        def self.database_port; '0' end

        def self.database_name; SpecHelper::Server::MYSQL.database end

        def self.database_user; SpecHelper::Server::MYSQL.username end

        def self.database_password; SpecHelper::Server::MYSQL.pass end

        def self.zabbix_server_ip; '192.168.1.1' end

        def self.zabbix_server_port; '666' end

        def self.zabbix_server_name; 'zabbix_test_server' end

        def self.zabbix_frontend_conf_file; '/usr/local/share/zabbix/frontends/php/conf/zabbix.conf.php' end

        def self.php_ini_path; "/etc/php5/cli/php.ini" end

        def self.php_ini_post_max_size; '32M' end

        def self.php_ini_max_execution_time; '300' end

        def self.php_ini_max_input_time; '300' end

        def self.php_ini_date_timezone; timezone end

        def self.timezone; 'UTC' end

        def self.pp(php_ini_path = 'false')
          <<-EOS
            class { 'zabbix': }

            class { 'zabbix::frontend::php::config':
              php_ini_path        => #{php_ini_path},
              database_hostname   => '#{database_hostname}',
              database_port       => '#{database_port}',
              database_name       => '#{database_name}',
              database_user       => '#{database_user}',
              database_password   => '#{database_password}',
              zabbix_server_ip    => '#{zabbix_server_ip}',
              zabbix_server_port  => '#{zabbix_server_port}',
              zabbix_server_name  => '#{zabbix_server_name}',
              timezone            => '#{timezone}',
            }
          EOS
        end
      end
    end
  end

  module Stack
    module ServerPHPMYSQL
      def self.apache_pp
        <<-EOS
            class { 'apache':
              mpm_module => 'prefork',
            }

            class { ['apache::mod::php']: }
        EOS
      end

      def self.apache_php_ini_path; '/etc/php5/apache2/php.ini' end

      def self.frontend_pp
        <<-EOS
            class { 'zabbix': }

            class { 'zabbix::frontend::php':
              php_ini_path        => '#{apache_php_ini_path}',
              database_hostname   => '#{SpecHelper::Frontend::PHP::Config.database_hostname}',
              database_port       => '#{SpecHelper::Frontend::PHP::Config.database_port}',
              database_name       => '#{SpecHelper::Frontend::PHP::Config.database_name}',
              database_user       => '#{SpecHelper::Frontend::PHP::Config.database_user}',
              database_password   => '#{SpecHelper::Frontend::PHP::Config.database_password}',
              zabbix_server_ip    => '#{SpecHelper::Frontend::PHP::Config.zabbix_server_ip}',
              zabbix_server_port  => '#{SpecHelper::Frontend::PHP::Config.zabbix_server_port}',
              zabbix_server_name  => '#{SpecHelper::Frontend::PHP::Config.zabbix_server_name}',
              timezone            => '#{SpecHelper::Frontend::PHP::Config.timezone}',
            }
        EOS
      end
    end
  end
end
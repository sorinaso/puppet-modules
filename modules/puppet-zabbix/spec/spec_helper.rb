require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper_acceptance'))

beaker_configuration('puppet-zabbix') do |c|
  beaker_install_local_module('puppet-cmmi')
  beaker_install_local_module('puppet-common') if beaker_is_provisioning?
  beaker_install_module('puppetlabs/stdlib') if beaker_is_provisioning?
  beaker_install_module('puppetlabs/mysql') if beaker_is_provisioning?
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
end
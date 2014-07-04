require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper_acceptance'))

beaker_configuration('puppet-zabbix') do |c|
  beaker_install_local_module('puppet-cmmi')
  beaker_install_local_module('puppet-common') if beaker_is_provisioning?
  beaker_install_module('puppetlabs/stdlib') if beaker_is_provisioning?
  beaker_install_module('puppetlabs/mysql') if beaker_is_provisioning?
end

module SpecHelper
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
      def self.script_path; "/etc/init.d/zabbix_server" end

      def self.script_user; "root" end

      def self.script_group; "root" end

      def self.script_mode; "root" end

      def self.clean_cmd
        "rm -rf #{script_path}"
      end
    end

    module Config
      def self.clean_cmd
        find_cmd = "find /usr/local/src -name 'zabbix_server.conf'"
        check_cmd = "#{find_cmd}|egrep zabbix_server.conf"
        copy_cmd = "#{find_cmd} -exec cp '{}' /usr/local/etc/ \\;"

        "(#{check_cmd}) && (#{copy_cmd})"
      end

      def self.conf_file; "/usr/local/etc/zabbix_server.conf" end

      def self.log_file; "/var/log/zabbix_server_test.log" end
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
    end
  end
end
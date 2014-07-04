require 'spec_helper'

describe 'zabbix::server::mysql class:' do
  context "when include" do
    it "should run without errors" do
      # Mysql install
      begin
        shell SpecHelper::Server::MYSQL.check_database_cmd
      rescue
        pp = <<-EOS
          class { 'mysql::server': } ->

          mysql::db { '#{SpecHelper::Server::MYSQL.database}':
             user     => '#{SpecHelper::Server::MYSQL.username}',
             password => '#{SpecHelper::Server::MYSQL.password}',
          }
        EOS

        apply_manifest(pp, :expect_changes => true)
      end

      # Clean
      shell SpecHelper::Server::Config.clean_cmd
      shell SpecHelper::Server::Service.clean_cmd
      shell SpecHelper::Server::MYSQL.clean_cmd

      # Instalo
      pp = <<-EOS
        class { 'mysql::server': } ->

        mysql::db { '#{SpecHelper::Server::MYSQL.database}':
           user     => '#{SpecHelper::Server::MYSQL.username}',
           password => '#{SpecHelper::Server::MYSQL.password}',
        } ->

        class { 'zabbix': } ->

        class { 'zabbix::server':
          service_enable    => true,
          service_ensure    => 'running',
          database_provider => 'mysql',
          database_name     => '#{SpecHelper::Server::MYSQL.database}',
          database_user     => '#{SpecHelper::Server::MYSQL.username}',
          database_password => '#{SpecHelper::Server::MYSQL.password}',
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file(SpecHelper::Server::Config.conf_file) do
      it { should contain "DBName=#{SpecHelper::Server::MYSQL.database}" }
      it { should contain "DBUser=#{SpecHelper::Server::MYSQL.username}" }
      it { should contain "DBPassword=#{SpecHelper::Server::MYSQL.password}" }
    end

    describe command(SpecHelper::Server::MYSQL.check_database_cmd) do
      it { should return_exit_status 0 }
    end

    describe command(SpecHelper::Server::MYSQL.check_schema_migrated_cmd) do
      it { should return_exit_status 0 }
    end

    describe command(SpecHelper::Server::MYSQL.check_data_migrated_cmd) do
      it { should return_exit_status 0 }
    end

    describe command(SpecHelper::Server::MYSQL.check_images_migrated_cmd) do
      it { should return_exit_status 0 }
    end

    describe file(SpecHelper::Server::Service.script_path) do
      it { should be_owned_by SpecHelper::Server::Service.script_user }
      it { should be_grouped_into SpecHelper::Server::Service.script_group }
      it { should be_executable.by_user(SpecHelper::Server::Service.script_user) }
    end

    describe command(SpecHelper::Server::Service.check_running_cmd) do
      it { should return_exit_status 0 }
    end
  end
end

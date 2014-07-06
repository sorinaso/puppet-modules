require 'spec_helper'

describe 'zabbix::server::mysql class:' do
  context "when include with service enabled and running" do
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

      pp = SpecHelper::Server::MYSQL.pp(:service_ensure => 'running', service_enable => 'true')

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

    describe service(SpecHelper::Server::Service.name) do
      it { should be_running }
      it { should be_enabled }
    end
  end

  context "when include with service disabled and stopped" do
    it "should run without errors and disable servcices" do
      # Instalo
      pp = SpecHelper::Server::MYSQL.pp(:service_ensure => 'stopped', service_enable => 'false')

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service(SpecHelper::Server::Service.name) do
      it { should_not be_running }
      it { should_not be_enabled }
    end
  end
end

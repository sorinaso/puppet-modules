require 'spec_helper'

describe 'zabbix::server::service class:' do
  context "when include" do
    it "should run without errors" do
      # Limpio el prefix directory.
      shell SpecHelper::Server::Service.clean_cmd

      # Instalo
      pp = <<-EOS
        class { 'zabbix': }

        class { 'zabbix::server::config':
          log_file => '#{SpecHelper::Server::Config::log_file}',
        } ->

        class { 'zabbix::server::service':
          ensure  => running,
          enable  => true,
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      #apply_manifest(pp, :catch_changes => true)
    end

    describe file(SpecHelper::Server::Service.script_path) do
      it { should be_owned_by SpecHelper::Server::Service.script_user }
      it { should be_grouped_into SpecHelper::Server::Service.script_group }
      it { should be_executable.by_user(SpecHelper::Server::Service.script_user) }
    end
  end
end

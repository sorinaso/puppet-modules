require 'spec_helper'

describe 'zabbix::server::config class:' do
  context "when include" do
    it "should run without errors" do
      # Limpio el prefix directory.
      shell SpecHelper::Server::Config.clean_cmd

      # Instalo
      pp = <<-EOS
        class { 'zabbix': }

        class { 'zabbix::server::config':
          log_file  => '#{SpecHelper::Server::Config::log_file}',
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file(SpecHelper::Server::Config.conf_file) do
      it { should contain "LogFile=#{SpecHelper::Server::Config.log_file}" }
    end
  end
end

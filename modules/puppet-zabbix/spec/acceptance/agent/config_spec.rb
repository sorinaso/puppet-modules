require 'spec_helper'

describe 'zabbix::agent::config class:' do
  context "when include" do
    it "should run without errors" do
      # Limpio el prefix directory.
      shell SpecHelper::Agent::Config.clean_cmd

      # Instalo
      pp = <<-EOS
        class { 'zabbix': }

        class { 'zabbix::agent::config':
          server_ip       => '#{SpecHelper::Agent::Config.server_ip}',
          agentd_log_file => '#{SpecHelper::Agent::Config.log_file}'
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file(SpecHelper::Agent::Config.agent_conf_file) do
      it { should contain "Server=#{SpecHelper::Agent::Config.server_ip}" }
    end

    describe file(SpecHelper::Agent::Config.agentd_conf_file) do
      it { should contain "LogFile=#{SpecHelper::Agent::Config.log_file}" }
    end
  end
end

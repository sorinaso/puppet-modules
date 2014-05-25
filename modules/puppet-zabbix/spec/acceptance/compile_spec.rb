require 'spec_helper'

describe 'zabbix::compile class:' do
  context "when compile " do
    it "should run without errors" do
      # Limpio el prefix directory.
      shell("sudo rm -rf /usr/local/*/*")

      # Instalo
      pp = <<-EOS
        class { 'zabbix::compile':
          source        => 'https://github.com/zabbix/zabbix/archive/2.2.3.tar.gz',
          src_folder    => 'zabbix-2.2.3',
          enable_server => true,
          enable_agent  => true,
          enable_mysql  => true,
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      #apply_manifest(pp, :catch_changes => true)
    end

    #describe file('/usr/local/bin/redis-server') { it should be_executable }
    #describe file('/usr/local/bin/redis-check-aof') { it should be_executable }
    #describe file('/usr/local/bin/redis-check-dump') { it should be_executable }
    #describe file('/usr/local/bin/redis-cli') { it should be_executable }
    #describe file('/usr/local/bin/redis-benchmark') { it should be_executable }
  end
end


require 'spec_helper'

describe 'zabbix mysql and php stack:' do
  context "when include with service enabled and running" do
      it "should run without errors" do
      # Mysql install
      begin
        shell SpecHelper::Server::MYSQL.check_database_cmd
      rescue
        apply_manifest(SpecHelper::Server::MYSQL.mysql_pp, :expect_changes => true)
      end

      # Clean
      shell SpecHelper::Server::Config.clean_cmd
      shell SpecHelper::Server::Service.clean_cmd
      shell SpecHelper::Server::MYSQL.clean_cmd
      shell SpecHelper::Frontend::PHP::Config.clean_cmd

      pp = SpecHelper::Server::MYSQL.zabbix_pp(
          :service_ensure => 'running',
          :service_enable => 'true'
      )

      apply_manifest(pp)

      apply_manifest(SpecHelper::Stack::ServerPHPMYSQL.frontend_pp)

      apply_manifest(SpecHelper::Stack::ServerPHPMYSQL.apache_pp)
    end
  end
end

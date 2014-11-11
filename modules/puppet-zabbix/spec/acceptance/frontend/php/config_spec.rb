require 'spec_helper'

describe 'zabbix::frontend::php::config class:' do
  context "when include doesn't manage php.ini" do
    it "should run without errors" do
      # Limpio el prefix directory.
      shell SpecHelper::Frontend::PHP::Config.clean_cmd

      # Instalo
      pp = SpecHelper::Frontend::PHP::Config.pp

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file(SpecHelper::Frontend::PHP::Config.zabbix_frontend_conf_file) do
      it { should contain(/.*DB\[.*TYPE.*\].*=.*MYSQL.*/) }
      it { should contain(/.*DB\[.*SERVER.*\].*=.*#{SpecHelper::Frontend::PHP::Config.database_hostname}.*/) }
      it { should contain(/.*DB\[.*PORT.*\].*=.*#{SpecHelper::Frontend::PHP::Config.database_port}.*/) }
      it { should contain(/.*DB\[.*DATABASE.*\].*=.*#{SpecHelper::Frontend::PHP::Config.database_name}.*/) }
      it { should contain(/.*DB\[.*PASSWORD.*\].*=.*#{SpecHelper::Frontend::PHP::Config.database_password}.*/) }
    end
  end

  context "when include and manage php.ini" do
    it "should run without errors" do
      # Limpio el prefix directory.
      shell SpecHelper::Frontend::PHP::Config.clean_cmd
      shell SpecHelper::Frontend::PHP::Config.install_php_cmd

      # Instalo
      pp = SpecHelper::Frontend::PHP::Config.pp("'#{SpecHelper::Frontend::PHP::Config.php_ini_path}'")

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file(SpecHelper::Frontend::PHP::Config.zabbix_frontend_conf_file) do
      it { should contain(/.*DB\[.*TYPE.*\].*=.*MYSQL.*/) }
      it { should contain(/.*DB\[.*SERVER.*\].*=.*#{SpecHelper::Frontend::PHP::Config.database_hostname}.*/) }
      it { should contain(/.*DB\[.*PORT.*\].*=.*#{SpecHelper::Frontend::PHP::Config.database_port}.*/) }
      it { should contain(/.*DB\[.*DATABASE.*\].*=.*#{SpecHelper::Frontend::PHP::Config.database_name}.*/) }
      it { should contain(/.*DB\[.*PASSWORD.*\].*=.*#{SpecHelper::Frontend::PHP::Config.database_password}.*/) }
    end

    describe file(SpecHelper::Frontend::PHP::Config.php_ini_path) do
      it { should contain(/^post_max_size.*=.*#{SpecHelper::Frontend::PHP::Config.php_ini_post_max_size}.*/) }
      it { should contain(/^max_execution_time.*=.*#{SpecHelper::Frontend::PHP::Config.php_ini_max_execution_time}.*/) }
      it { should contain(/^max_input_time.*=.*#{SpecHelper::Frontend::PHP::Config.php_ini_max_input_time}.*/) }
      it { should contain(/^date.timezone.*=.*#{SpecHelper::Frontend::PHP::Config.timezone}.*/) }
    end
  end
end

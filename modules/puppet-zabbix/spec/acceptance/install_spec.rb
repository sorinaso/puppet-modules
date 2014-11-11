require 'spec_helper'

include SpecHelper::Install

describe 'zabbix::install class:' do
  context "when install" do
    it "should run without errors" do
      # Limpio el prefix directory.
      shell clean_cmd

      # Instalo
      pp = <<-EOS
        class { 'zabbix': }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    binaries.each do |binary|
      describe file(binary) do
        it { should be_owned_by binaries_user }
        it { should be_grouped_into binaries_group }
        it { should be_executable.by_user(binaries_user) }
      end
    end
  end
end


require 'spec_helper'

describe 'apache class:' do
  before(:all) do
    pp = <<-EOS
      class { 'apache':
        ensure => absent,
      }
    EOS

    apply_manifest(pp)
  end

  context "when no paramaters given" do
    it "should run without errors" do
      pp = "class { 'apache': }"
      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)

    end

    describe package('apache2') do
      it { should be_installed }
    end

    describe service('apache2') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(80) do
      it { should be_listening }
    end
  end

  context "when { service_ensure => stopped, service_enable => false}" do
    it "should run without errors" do
      pp = <<-EOS
      class { 'apache':
        service_ensure => stopped,
        service_enable => false,
      }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('apache2') do
      it { should be_installed }
    end

    describe service('apache2') do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe port(80) do
      it { should_not be_listening }
    end
  end

  context "when { ensure => absent }" do
    it "should run without errors" do
      pp = <<-EOS
      class { 'apache':
        ensure => absent,
      }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('apache2') do
      it { should_not be_installed }
    end

    describe service('apache2') do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe port(80) do
      it { should_not be_listening }
    end
  end
end


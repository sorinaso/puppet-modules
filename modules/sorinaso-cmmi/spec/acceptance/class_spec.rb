require 'spec_helper'

describe 'cmmi class:' do
  context "when compile redis" do
    it "should run without errors" do
      # Limpio el prefix directory.
      shell("sudo rm -rf /usr/local/*/*")

      # Instalo
      pp = <<-EOS
        cmmi { 'redis':
          download        => 'http://redis.googlecode.com/files/redis-2.6.13.tar.gz',
          creates         => '/usr/local/bin/redis-server',
          configure_cmd   => false,
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/usr/local/bin/redis-server') { it should be_executable }
    describe file('/usr/local/bin/redis-check-aof') { it should be_executable }
    describe file('/usr/local/bin/redis-check-dump') { it should be_executable }
    describe file('/usr/local/bin/redis-cli') { it should be_executable }
    describe file('/usr/local/bin/redis-benchmark') { it should be_executable }
  end
end


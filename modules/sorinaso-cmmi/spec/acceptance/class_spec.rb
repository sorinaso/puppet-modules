require 'spec_helper'

describe 'cmmi class:' do
  it "should install redis" do
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

    # Debe haber instalado los binarios.
    file('/usr/local/bin/redis-server').should be_executable
    file('/usr/local/bin/redis-check-aof').should be_executable
    file('/usr/local/bin/redis-check-dump').should be_executable
    file('/usr/local/bin/redis-cli').should be_executable
    file('/usr/local/bin/redis-benchmark').should be_executable
  end
end


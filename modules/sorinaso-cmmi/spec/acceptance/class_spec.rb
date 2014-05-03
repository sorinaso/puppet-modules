require 'spec_helper'

describe 'cmmi class:' do
  it "should install redis" do
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
end


require 'spec_helper'

include SpecHelper::Compile

describe 'cmmi class:' do
  context "when compile redis { configure_cmd => false }" do
    it "should run without errors" do
      shell memcached_clean_cmd
      shell memcached_download_src_cmd
      shell memcached_uncompress_cmd

      pp = <<-EOS
        class { 'cmmi': }

        cmmi::compile { 'memcached':
          directory       => '#{memcached_src_directory}',
          creates         => '#{memcached_binary}',
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file(memcached_binary) do
      it { should be_executable }
    end

    describe file(memcached_src_directory) do
      it { should_not be_directory }
    end
  end

  context "when compile redis { configure_cmd => false }" do
    it "should run without errors" do
      shell redis_clean_cmd
      shell redis_download_src_cmd
      shell redis_uncompress_cmd

      pp = <<-EOS
        class { 'cmmi': }

        cmmi::compile { 'redis':
          directory       => '#{redis_src_directory}',
          creates         => '#{redis_binaries[0]}',
          configure_cmd   => false,
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    redis_binaries.each do |binary|
      describe file(binary) do
        it { should be_executable }
      end
    end

    describe file(redis_src_directory) do
      it { should_not be_directory }
    end
  end

  context "when compile redis { configure_cmd => false, rm_build_folder => false }" do
    it "should run without errors" do
      shell redis_clean_cmd
      shell redis_download_src_cmd
      shell redis_uncompress_cmd

      pp = <<-EOS
        class { 'cmmi': }

        cmmi::compile { 'redis':
          directory       => '#{redis_src_directory}',
          creates         => '#{redis_binaries[0]}',
          configure_cmd   => false,
          rm_build_folder => false,
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    redis_binaries.each do |binary|
      describe file(binary) do
        it { should be_executable }
      end
    end

    describe file(redis_src_directory) do
      it { should be_directory }
    end
  end
end


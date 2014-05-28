require 'spec_helper'

include SpecHelper::Extract

describe 'cmmi::extract class:' do
  context "when extension .tar.bz2" do
    it "should run without errors" do
      shell test_clean_cmd
      shell test_tarbz2_download_cmd

      pp = <<-EOS
        class { 'cmmi': }

        cmmi::extract { 'test_extract':
          file      => '#{test_tarbz2_file}',
          extension => '.tar.bz2',
          user      => 'root',
          creates   => '#{test_target_directory}',
          timeout   => 600,
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file(test_target_directory) do
      it { should be_directory }
    end

    describe file(test_tarbz2_file) do
      it { should be_file }
    end
  end


  context "when extension .tar.gz" do
    it "should run without errors" do
      shell test_clean_cmd
      shell test_targz_download_cmd

      pp = <<-EOS
        class { 'cmmi': }

        cmmi::extract { 'test_extract':
          file      => '#{test_targz_file}',
          extension => '.tar.gz',
          user      => 'root',
          creates   => '#{test_target_directory}',
          timeout   => 600,
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file(test_target_directory) do
      it { should be_directory }
    end

    describe file(test_targz_file) do
      it { should be_file }
    end
  end

  context "when custom command" do
    it "should run without errors" do
      shell test_clean_cmd
      shell test_targz_download_cmd

      pp = <<-EOS
        class { 'cmmi': }

        cmmi::extract { 'test_extract':
          file      => '#{test_targz_file}',
          command   => '/bin/tar xvfz #{test_targz_file}',
          user      => 'root',
          creates   => '#{test_target_directory}',
          timeout   => 600,
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file(test_target_directory) do
      it { should be_directory }
    end

    describe file(test_targz_file) do
      it { should be_file }
    end
  end

  context "when bad extension" do
    it "shouldn't run" do
      pp = <<-EOS
        class { 'cmmi': }

        cmmi::extract { 'test_extract':
          file      => '#{test_targz_file}',
          extension => '.pirulito',
          user      => 'root',
          creates   => '#{test_target_directory}',
          timeout   => 600,
        }
      EOS

      apply_manifest(pp, :expect_failures => true)
    end
  end

  context "when no extension or custom command" do
    it "shouldn't run" do
      pp = <<-EOS
        class { 'cmmi': }

        cmmi::extract { 'test_extract':
          file      =>'#{test_targz_file}',
          user      => 'root',
          creates   => '#{test_target_directory}',
          timeout   => 600,
        }
      EOS

      apply_manifest(pp, :expect_failures => true)
    end
  end

  context "when extension and custom command" do
    it "shouldn't run" do
      pp = <<-EOS
        class { 'cmmi': }

        cmmi::extract { 'test_extract':
          file      =>'#{test_targz_file}',
          extension => '.tar.gz',
          command   => '/bin/tar xvfz #{test_targz_file}',
          user      => 'root',
          creates   => '#{test_target_directory}',
          timeout   => 600,
        }
      EOS

      apply_manifest(pp, :expect_failures => true)
    end
  end
end

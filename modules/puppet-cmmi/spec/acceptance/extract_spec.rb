require 'spec_helper'

include SpecHelper::Extract

describe 'cmmi::extract class:' do
  context "when extract .tar.bz2" do
    it "should run without errors" do
      shell test_clean_cmd
      shell test_tarbz2_download_cmd

      pp = <<-EOS
        class { 'cmmi': }

        cmmi::extract { '#{test_tarbz2_file}':
          extension => '.tar.bz2',
          user      => 'root',
          creates   => '#{test_target_directory}',
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


  context "when extract .tar.gz" do

    it "should run without errors" do
      shell test_clean_cmd
      shell test_targz_download_cmd

      pp = <<-EOS
        class { 'cmmi': }

        cmmi::extract { '#{test_targz_file}':
          extension => '.tar.gz',
          user      => 'root',
          creates   => '#{test_target_directory}',
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
end

require 'spec_helper'

include SpecHelper::Install

describe 'cmmi::install type:' do
  context "when install memcached" do
    it "should run without errors" do
      shell clean_cmd

      pp = <<-EOS
        class { 'cmmi': }

        cmmi::install { 'memcached':
          download_url                    => '#{download_url}',
          download_filename               => '#{download_filename}',
          extract_extension               => '#{extract_extension}',
          compilation_directory           => '#{test_directory}',
          compilation_configure_cmd       => '#{compilation_configure_cmd}',
          compilation_make_cmd            => '#{compilation_make_cmd}',
          compilation_source_folder_name  => '#{compilation_source_folder_name}',
          compilation_creates             => '#{compilation_creates}',
          compilation_rm_source_folder    => false,
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end

require 'spec_helper'

include SpecHelper::Download

describe 'cmmi::download class:' do
  context "when download kernel changelog sign" do
    it "should run without errors" do
      #Borro el archivo.
      shell "rm -f #{test_directory}/#{test_file}"

      pp = <<-EOS
        class { 'cmmi': }

        cmmi::download { 'test_download':
          url       => '#{test_url}',
          directory => '#{test_directory}',
          creates   => '#{test_directory}/#{test_file}',
          user      => 'root',
          timeout   => 120,
        }
      EOS

      apply_manifest(pp, :expect_changes => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("#{test_directory}/#{test_file}") do
      it { should be_file }
    end
  end
end


require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper_acceptance'))

beaker_configuration('puppet-cmmi') do |c|
  beaker_install_local_module('puppet-common') if beaker_is_provisioning?
end

module SpecHelper
  module Download
    def test_file; 'ChangeLog-3.0.11.sign' end
    def test_directory; '/tmp' end
    def test_url; 'https://www.kernel.org/pub/linux/kernel/v3.0/ChangeLog-3.0.11.sign' end
    def test_path; File.join(test_directory, test_file) end
  end

  module Extract
    def test_directory; "/tmp" end
    def test_target_directory; "#{test_directory}/iproute2-3.2.0" end
    def test_clean_cmd; "rm -rf #{test_target_directory}" end

    # .tar.bz2
    def test_tarbz2_url; 'https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-3.2.0.tar.bz2' end
    def test_tarbz2_file; "#{test_directory}/iproute2-3.2.0.tar.bz2" end
    def test_tarbz2_download_cmd; "test -f #{test_tarbz2_file} | (cd #{test_directory} && wget -q #{test_tarbz2_url})" end

    # .tar.gz
    def test_targz_url; 'https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-3.2.0.tar.gz' end
    def test_targz_file; "#{test_directory}/iproute2-3.2.0.tar.gz" end
    def test_targz_download_cmd; "test -f #{test_targz_file} | (cd #{test_directory} && wget -q #{test_targz_url})" end
  end
end
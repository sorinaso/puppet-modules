require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper_acceptance'))

beaker_configuration('puppet-cmmi') do |c|
  beaker_install_local_module('puppet-common') if beaker_is_provisioning?
  shell('apt-get install libevent-dev') if beaker_is_provisioning?
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

  module Compile
    def test_directory; "/tmp" end

    def redis_src_file; File.join(test_directory, "redis-2.6.13.tar.gz") end

    def redis_src_directory; File.join(test_directory, "redis-2.6.13") end

    def redis_download_src_cmd;
      "test -f #{redis_src_file} | (cd #{test_directory} && wget -q http://redis.googlecode.com/files/redis-2.6.13.tar.gz)"
    end

    def redis_uncompress_cmd;
      "rm -rf #{redis_src_directory} && (cd #{test_directory} && tar xvfz redis-2.6.13.tar.gz)"
    end

    def redis_clean_cmd; "rm -rf #{redis_src_directory} && rm -rf /usr/local/*/*" end

    def redis_binaries
      [
        '/usr/local/bin/redis-server',
        '/usr/local/bin/redis-check-aof',
        '/usr/local/bin/redis-check-dump',
        '/usr/local/bin/redis-cli',
        '/usr/local/bin/redis-benchmark'
      ]
    end


    def memcached_src_file; File.join(test_directory, "memcached-1.4.20.tar.gz") end

    def memcached_src_directory; File.join(test_directory, "memcached-1.4.20") end

    def memcached_download_src_cmd;
      "test -f #{memcached_src_file} | (cd #{test_directory} && wget -q http://memcached.org/files/memcached-1.4.20.tar.gz)"
    end

    def memcached_uncompress_cmd;
      "rm -rf #{memcached_src_directory} && (cd #{test_directory} && tar xvfz memcached-1.4.20.tar.gz)"
    end

    def memcached_clean_cmd; "rm -rf #{memcached_src_directory} && rm -rf /usr/local/*/*" end

    def memcached_binary; '/usr/local/bin/memcached' end
  end

  module Install
    def test_directory; "/tmp" end

    def download_url; "http://memcached.org/files/memcached-1.4.20.tar.gz" end

    def download_filename; "memcached-1.4.20.tar.gz" end

    def compilation_source_folder_name; "memcached-1.4.20" end

    def compilation_source_path; File.join(self.test_directory, "memcached-1.4.20") end

    def compilation_configure_cmd; File.join(compilation_source_path, "configure") end

    def compilation_make_cmd; "/usr/bin/make && /usr/bin/make install" end

    def compilation_creates; '/usr/local/bin/memcached' end

    def extract_extension; ".tar.gz" end

    def clean_cmd; "rm -rf #{compilation_source_path} && rm -rf #{download_filename} rm -rf /usr/local/*/*" end
  end
end
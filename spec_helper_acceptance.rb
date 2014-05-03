require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

def beaker_configuration(module_name)
  RSpec.configure do |c|
    module_path = File.expand_path(File.join(File.dirname(__FILE__), 'modules', module_name))
    vm_module_path = "/etc/puppet/modules/#{module_name}"

    # Readable test descriptions
    c.formatter = :documentation

    c.before :suite do
      if ENV['BEAKER_provision'] != 'no'
        #shell("sudo echo 'Acquire::http { Proxy \"http://192.168.2.7:3142\"; };' > /etc/apt/apt.conf.d/01apt-cacher-ng-proxy")
        shell('wget "https://apt.puppetlabs.com/puppetlabs-release-$(lsb_release -sc).deb" -O /tmp/puppet.deb')
        shell('dpkg -i /tmp/puppet.deb')
        shell('sudo apt-get update')
        shell('sudo apt-get -y install puppet')
      end

      # Borramos los modulos viejos.
      shell("sudo rm -rf #{vm_module_path}")

      puppet_module_install(
        :source => module_path,
        :module_name => module_name
      )
    end
  end
end
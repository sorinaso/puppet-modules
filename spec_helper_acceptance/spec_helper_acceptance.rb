require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

def beaker_module_name_without_org(module_name)
  module_name.split('-')[1]
end

def beaker_local_module_path(module_name)
  File.expand_path(File.join(File.dirname(__FILE__), '..', 'modules', "#{module_name}"))
end

def beaker_vm_module_path(module_name)
  "/etc/puppet/modules/#{beaker_module_name_without_org(module_name)}"
end

def beaker_install_local_module(module_name)
  # Borramos los modulos viejos.
  shell("sudo rm -rf #{beaker_vm_module_path(module_name)}")

  puppet_module_install(
      :source => beaker_local_module_path(module_name),
      :module_name => beaker_module_name_without_org(module_name)
  )
end

def beaker_install_module(module_name)
  shell("puppet module install #{module_name}")
end

def beaker_install_puppet
  shell('wget "https://apt.puppetlabs.com/puppetlabs-release-$(lsb_release -sc).deb" -O /tmp/puppet.deb')
  shell('dpkg -i /tmp/puppet.deb')
  shell('sudo apt-get update')
  shell('sudo apt-get -y install puppet')
end

def beaker_is_provisioning?
  ENV['BEAKER_provision'] != 'no'
end

def beaker_configuration(module_name, &block)
  RSpec.configure do |c|
    # Readable test descriptions
    c.formatter = :documentation

    c.before :suite do
      if beaker_is_provisioning?
        beaker_install_puppet
      end

      beaker_install_local_module(module_name)

      yield c if block_given?
    end
  end
end
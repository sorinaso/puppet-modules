require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'json'
require 'find'

#def shell(cmd); puts cmd end

module AcceptanceTestEnvironment
  class PuppetModule

    attr_reader :name, :user, :spec

    def initialize(spec)
      fail "El spec #{spec} no es un modulo" if not spec =~ %r"^\w+/\w+$"

      @spec = spec

      parts = @spec.split('/')

      @name = parts[1]
      @user = parts[0]
    end

    def from_local_path?; @user == 'sorinaso' end

    def from_forge?; !from_local_path? end

    def local_path
      fail "El spec #{@spec} no pertenece a un modulo local" if not from_local_path?

      File.expand_path(File.join(File.dirname(__FILE__), '..', 'modules', "puppet-#{@name}"))
    end

    def vm_path; "/etc/puppet/modules/#{@name}" end
  end

  class BeakerVM
    def install_puppet_module(puppet_module)
      if puppet_module.from_local_path?
        install_puppet_local_module(puppet_module)
      else
        install_puppet_forge_module(puppet_module)
      end
    end

    def install_puppet
      shell('wget "https://apt.puppetlabs.com/puppetlabs-release-$(lsb_release -sc).deb" -O /tmp/puppet.deb')
      shell('dpkg -i /tmp/puppet.deb')
      shell('sudo apt-get update')
      shell('sudo apt-get -y install puppet')
    end

    def is_provisioning?; ENV['BEAKER_provision'] != 'no' end

    private

    def install_puppet_local_module(puppet_module)
      # Borramos los modulos viejos.
      shell("sudo rm -rf #{puppet_module.vm_path}")

      # Instalamos el modulo.
      puppet_module_install(
          :source => puppet_module.local_path,
          :module_name => puppet_module.name
      )
    end

    def install_puppet_forge_module(puppet_module)
      shell("puppet module install #{puppet_module.spec}")
    end
  end

  def self.beaker_vm; BeakerVM.new end

  def self.is_provisioning?; beaker_vm.is_provisioning? end

  def self.install_puppet_module(spec); beaker_vm.install_puppet_module(PuppetModule.new(spec)) end

  def self.install_puppet; beaker_vm.install_puppet end

  def self.testing_module_metadata
    results = Find.find("metadata.json").to_a

    fail "Se encontro mas de un metadata.json #{results}" if results.size > 1

    fail "No se encontro un metadata.json #{results}" if results.size < 1

    results[0]

    JSON.parse(File.read(results[0]))
  end

  def self.start(&block)
    RSpec.configure do |c|
      # Readable test descriptions
      c.formatter = :documentation

      c.before :suite do
        if true#AcceptanceTestEnvironment.is_provisioning?
          AcceptanceTestEnvironment.install_puppet

          AcceptanceTestEnvironment.testing_module_metadata["dependencies"].each do |d|
            AcceptanceTestEnvironment.install_puppet_module(d["name"])
          end
        end

        AcceptanceTestEnvironment.install_puppet_module(
            AcceptanceTestEnvironment.testing_module_metadata["name"].gsub("-", "/")
        )

        yield c if block_given?
      end
    end
  end
end




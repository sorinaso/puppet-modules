  Vagrant::Config.run do |config|
  config.vm.define :puppet_testing do |puppet_testing|
    puppet_testing.vm.customize ["modifyvm", :id, "--name", "puppet_testing"]
    puppet_testing.vm.box = 'base_puppet_testing'
    puppet_testing.vm.host_name = "testmodules.localhost"
    puppet_testing.vm.forward_port 22, 6667
    puppet_testing.vm.share_folder "root", "/mnt/host", "guest"

    puppet_testing.vm.provision :puppet do |puppet|
      puppet.manifests_path = "./manifests"
      puppet.manifest_file = "site.pp"
      puppet.module_path  = "./modules"
      puppet.options = '--show_diff'
      puppet.options << ' --verbose --debug' if ENV['PUPPET_DEBUG']
      puppet.options << ' --noop' if ENV['PUPPET_NOOP']
      puppet.options << ' --graph'
    end
  end

  config.vm.define :base_puppet_testing do |base_puppet_testing|
    base_puppet_testing.vm.customize ["modifyvm", :id, "--name", "base_puppet_testing"]
    base_puppet_testing.vm.box = 'ubuntu-12.0.4-LTS-server-x64'
    base_puppet_testing.vm.host_name = "testmodules.localhost"

    base_puppet_testing.vm.provision :puppet do |puppet|
      puppet.manifests_path = "./vms"
      puppet.manifest_file = "base_puppet_testing.pp"
      puppet.module_path  = "./modules"
      puppet.options = '--show_diff'
      puppet.options << ' --verbose --debug' if ENV['PUPPET_DEBUG']
      puppet.options << ' --noop' if ENV['PUPPET_NOOP']
    end
  end
end


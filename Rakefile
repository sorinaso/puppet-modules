# VM parameters.
vm_name = 'puppet_testing'

# Graph directories.
host_graph_dir = " ./guest/graphs"
guest_graph_dir = "/var/lib/puppet/state/graphs"
guest_host_dir = "/mnt/host"

require 'rake/admin/puppet'
require 'rake/admin/vagrant'

namespace :puppet_testing do
  namespace :base do
    namespace :vm do
      Rake::Admin::Vagrant::Local.new do |t|
        t.vm_name = 'base_puppet_testing'
      end
    end
  end

  namespace :test do
    namespace :vm do
      Rake::Admin::Vagrant::Local.new do |t|
        t.vm_name = 'puppet_testing'
      end

      desc "Repackage and deploy de base machine"
      task :rebase => ['puppet_testing:base:vm:recreate'] do
        box_path = 'base_puppet_testing.box'
        box_name = 'base_puppet_testing'

        sh "rm #{box_path} -f"
        Rake::Task['puppet_testing:base:vm:package'].execute
        sh "vagrant box add #{box_name} #{box_path} -f"
        sh "rm #{box_path} -f"
      end
    end
  end
end

#task :up => ['puppet_testing:up'] do
#  sh "vagrant ssh -c 'sudo mkdir -p #{guest_graph_dir}'"
#end

#desc "SSH to the machine"
#task :ssh => ['vm:up'] do
#  sh "vagrant ssh #{vm_name}"
#end
#namespace :graphs do
#  desc "Generate puppet graph images"
#  task :create do
#    sh "rm -rf #{host_graph_dir}"
#    sh "vagrant ssh -c 'sudo cp -rf #{guest_graph_dir} #{guest_host_dir}'"
#
#    ['expanded_relationships', 'relationships', 'resources'].each do |fn|
#      sh "dot #{host_graph_dir}/#{fn}.dot -Tpng -o#{host_graph_dir}/#{fn}.png"
#    end
#  end
#
#  desc "View puppet graph images"
#  task :view => [:create] do
#    sh "killall mirage || echo 'mirage not running'"
#    sh "mirage #{host_graph_dir}"
#  end
#end


desc "Run the test"
task :test => ['puppet_testing:test:vm:provision']

desc "Recreate VM and run the test"
task :retest => ['puppet_testing:test:vm:recreate']

desc "Run the test(dry run)"
task :test_dry_run do
  sh "PUPPET_NOOP=1 rake test"
end



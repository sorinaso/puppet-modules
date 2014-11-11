require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec_system) do |c|
  c.pattern = "spec/acceptance/**/*_spec.rb"
end

namespace :beaker do
  desc "Corre los tests de beaker"
  task :test do
    ENV['BEAKER_setfile'] ||= "/home/sorin/mis_proyectos/puppet/puppet-modules/spec_helper_acceptance/nodesets/default.yml"
    ENV['BEAKER_provision'] ||= 'yes'
    ENV['BEAKER_destroy'] ||= 'yes'

    Rake::Task['spec_system'].invoke()
  end
end

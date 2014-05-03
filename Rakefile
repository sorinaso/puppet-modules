require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec_system) do |c|
  c.pattern = "spec/acceptance/**/*_spec.rb"
end

namespace :beaker do
  task :test do
    Rake::Task['rspec_system'].invoke()
  end
end

namespace :librarian do
  desc "Do a librarian-puppet install"
  task :install do
    sh "librarian-puppet install"
  end

  desc "Do a librarian-puppet update"
  task :update do
    sh "librarian-puppet update"
  end

  desc "Do a librarian-puppet clean"
  task :clean do
    sh "librarian-puppet clean"
  end
end

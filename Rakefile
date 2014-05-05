require 'rspec/core/rake_task'

namespace :beaker do
  desc "Corre los tests de todos los modulos con aceptancia"
  task :test_all do
    modules_summary_log = []
    modules_summary_log << "Summary:\n\n"

    Dir.glob("modules/*/spec/acceptance") do |f|
      module_directory = File.expand_path(f).gsub("/spec/acceptance", "")
      module_name = module_directory.split("/").last

      failed = false

      begin
        sh "cd #{module_directory} && BEAKER_provision=yes BEAKER_destroy=yes rake spec_system"
      rescue
        failed = true
      end

      if failed
        modules_summary_log << "#{module_name}...FAILED"
      else
        modules_summary_log << "#{module_name}...OK"
      end
    end

    puts modules_summary_log
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

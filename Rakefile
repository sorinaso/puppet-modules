require 'rspec/core/rake_task'

namespace :beaker do
  desc "Corre los tests de todos los modulos con aceptancia"
  task :test_all do
    modules_summary_log = []
    modules_summary_log << "Summary:\n\n"

    some_failed = false

    Dir.glob("modules/*/spec/acceptance") do |f|
      module_directory = File.expand_path(f).gsub("/spec/acceptance", "")
      module_name = module_directory.split("/").last

      failed = false

      begin
        sh "cd #{module_directory} && BEAKER_provision=yes BEAKER_destroy=yes rake beaker:test"
      rescue
        failed = true
      end

      if failed
        some_failed = true
        modules_summary_log << "#{module_name}...FAILED"
      else
        modules_summary_log << "#{module_name}...OK"
      end
    end

    puts modules_summary_log

    fail if some_failed
  end
end

desc "Corre el test de todos los modulos en el branch master de github"
task :test_github_master do
  modules_directory = "/tmp/puppet-modules"

  sh "rm -rf #{modules_directory}"
  sh "cd /tmp && git clone https://github.com/sorinaso/puppet-modules.git"
  sh "cd #{modules_directory} && rake beaker:test_all"
  sh "rm -rf #{modules_directory}"
end

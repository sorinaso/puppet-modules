class admin::rake::admin_tasks($ensure, $version) {
  $gem_name = 'rake-admin'
  $gem_version = $version

  $gem = "${gem_name}-${version}.gem"

  $gem_source = "puppet://admin/rake/admin_tasks/${gem}"

  $gem_dest = "/tmp/${gem}"

  $gem_install_cmd = "/bin/bash -l -c 'gem install --local ${gem_dest}'"
  $gem_uninstall_cmd = "/bin/bash -l -c 'gem uninstall rake-admin -v=${version}'"
  $gem_check_cmd = "/bin/bash -l -c 'gem query --installed -v ${version} -n rake-admin'"


  exec { "install-rake-admin-${version}":
    command => $gem_install_cmd,
    unless  => $gem_check_cmd,
  }

  exec { "uninstall-rake-admin-${version}":
    command => $gem_uninstall_cmd,
    onlyif  => $gem_check_cmd,
  }
}
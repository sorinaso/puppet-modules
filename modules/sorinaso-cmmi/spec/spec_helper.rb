require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper_acceptance'))

beaker_configuration('sorinaso-cmmi') do |c|
  beaker_install_local_module('sorinaso-common') if beaker_is_provisioning?
end
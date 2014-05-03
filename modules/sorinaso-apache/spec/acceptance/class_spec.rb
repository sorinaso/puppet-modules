require 'spec_helper'

describe 'apache class:' do
  before(:all) do
    pp = <<-EOS
      class { 'apache':
        ensure => absent,
      }
    EOS

    apply_manifest(pp)
  end

  it "should install with service running" do
    # Instalo
    pp = "class { 'apache': }"
    apply_manifest(pp, :expect_changes => true)
    apply_manifest(pp, :catch_changes => true)

    # El paquete debe estar instalado
    package('apache2').should be_installed

    # El servicio habilitado y corriendo.
    service('apache2').should be_enabled
    service('apache2').should be_running

    # El puerto 80 escuchando.
    port(80).should be_listening
  end

  it "should install without service enabled or running" do
    # Instalo
    pp = <<-EOS
    class { 'apache':
      service_ensure => stopped,
      service_enable => false,
    }
    EOS

    apply_manifest(pp, :expect_changes => true)
    apply_manifest(pp, :catch_changes => true)

    # El paquete debe estar instalado
    package('apache2').should be_installed

    # El servicio no debe estar habilitado ni corriendo.
    service('apache2').should_not be_enabled
    service('apache2').should_not be_running

    # El puerto 80 no debe estar escuchando.
    port(80).should_not be_listening
  end

  it "should uninstall" do
    # Instalo
    pp = <<-EOS
    class { 'apache':
      ensure => absent,
    }
    EOS

    apply_manifest(pp, :expect_changes => true)
    apply_manifest(pp, :catch_changes => true)

    # El paquete debe estar instalado
    package('apache2').should_not be_installed

    # El servicio no debe estar habilitado ni corriendo.
    service('apache2').should_not be_enabled
    service('apache2').should_not be_running

    # El puerto 80 no debe estar escuchando.
    port(80).should_not be_listening
  end
end


# == Class: jenkins::install
#
# Esta clase agrega el repositorio de jenkins al package manager del sistema operativo,
# esto se repite cada vez que se corre puppet.
#
# TODO: Determinar -CUANDO- se tiene que correr esto para actualizar jenkins.
#
# === Authors
#
# Alejandro Souto <alejandro@panaldeideas.com>
#
class jenkins::install {
  case $operatingsystem {
    'ubuntu': {
      apt::source { 'jenkins':
        location   => 'http://apt.puppetlabs.com',
        repos      => 'main',
        key        => '4BD6EC30',
        key_server => 'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key',
      }

      package { 'jenkins':
        ensure  => installed,
        require => Apt::Source['jenkins'],
      }

      if $jenkins::user != undef {
        # Change service run user variable.
        editfile::config { "/etc/default/jenkins change JENKINS_USER variable":
          path    => '/etc/default/jenkins',
          entry   => 'JENKINS_USER',
          sep     => '=',
          ensure  => $jenkins::user,
          require => Package['jenkins'],
          notify  => Exec['jenkins user owner']
        }

        # Jenkins user perms.
        exec { 'jenkins user owner':
          command     => "/bin/chown -R ${jenkins::user} /var/log/jenkins /var/lib/jenkins /var/run/jenkins",
          user        => "root",
          require     => Package['jenkins'],
          refreshonly => true,
          notify      => Service['jenkins'],
        }

        # Service.
        service { 'jenkins':
          ensure  => "running",
          enable  => "true",
          require => Package["jenkins"],
        }
      }
    }
    default: { fail("Unsupported OS ${operatingsystem}") }
  }
}
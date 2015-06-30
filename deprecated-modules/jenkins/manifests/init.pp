# == Class: jenkins
#
# Esta clase instala jenkins en el sistema operativo.
#
# === Paramters
# [user]
# User that runs jenkins.
#
# === Authors
#
# Alejandro Souto <alejandro@panaldeideas.com>
#
class jenkins($user = undef) {
  include jenkins::install
}

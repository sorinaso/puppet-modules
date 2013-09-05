class admin::vagrant::puppet_master(
$etcdir = '/etc/puppet',
$logdir ='/var/log/puppet',
$vardir ='/var/lib/puppet',
$rundir ='/var/run/puppet'
) {

  include puppet::master

  $ssldir="${vardir}/ssl"

  file { "${etcdir}/puppet.conf":
    content =>
"[main]
logdir=${logdir}
vardir=${vardir}
ssldir=\$vardir/ssl
rundir=${rundir}
factpath=\$vardir/facter
templatedir=\$confdir/templates
modulepath=/tmp/vagrant-puppet/modules-0:/tmp/vagrant-puppet/modules-1
manifestdir=/tmp/vagrant-puppet/manifests

[master]
# These are needed when the puppetmaster is run by passenger
# and can safely be removed if webrick is used.
autosign = true
#ssl_client_header = SSL_CLIENT_S_DN
#ssl_client_verify_header = SSL_CLIENT_VERIFY
"
  }
}
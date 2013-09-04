class admin::vagrant::puppet_master(
$puppet_etc = '/etc/puppet',
$host_puppet_dir = '/mnt/puppet_host',
$user = 'root'
) {

  include puppet::master

  file { '/etc/puppet/puppet.conf':
    content =>
"[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=\$vardir/lib/facter
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
# == Class: admin::mail::gmail_send_only
#
# This class creates a smtp that relays GMail.
#
# === Parameters
#
# [*admin_address*]
# The from email.
#
# [*gmail_user*]
# GMail user.
#
# [*gmail_password*]
# GMail password.
#
# === Variables
#
# === Examples
#
# === Authors
#
# Alejandro Souto <sorinaso@gmail.com>
#

class admin::mail::gmail_send_only(
$admin_address,
$gmail_user,
$gmail_password
) {
  apt::ppa { 'ppa:mikko-red-innovation/ppa': } ->

  class { '::nullmailer':
    adminaddr   => $admin_address,
    remoterelay => "smtp.gmail.com",
    remoteopts  => "--user=${gmail_user} --pass=${gmail_password} --starttls --port=587"
  }
}

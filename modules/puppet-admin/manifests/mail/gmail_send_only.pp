class admin::mail::gmail_send_only(
$admin_address,
$gmail_user,
$gmail_password
) {
  class {'apt': }

  package { ['python-software-properties', 'software-properties-common']: } ->

  apt::ppa { 'ppa:mikko-red-innovation/ppa': } ->

  class { '::nullmailer':
    adminaddr   => $admin_address,
    remoterelay => "smtp.gmail.com",
    remoteopts  => "--user=${gmail_user} --pass=${gmail_password} --starttls --port=587"
  }
}

#Define un vhost de apache a partir de su contenido.
define apache::vhost($ensure=present, $content = undef, $file = undef) {
  case $ensure {
    present: {
      $ensure_file = present
      $esure_link = link
    }
    absent: {
      $ensure_file = absent
      $ensure_link = absent
    }
    default: { fail("$ensure must be present or absent.") }
  }

  if $file != undef {
    file { "/etc/apache2/sites-available/${name}":
      ensure  => $ensure_file,
      mode    => '644',
      source  => $file,
      #notify => Exec['apache-restart'],
    }
  } elsif $content != undef {
    file { "/etc/apache2/sites-available/${name}":
      ensure  => $ensure_file,
      mode    => '644',
      content => $content,
      #notify => Exec['apache-restart'],
    }
  } else {
    fail("apache::vhost must receive file path or content to fill the vhost entry.")
  }

  if $name != 'default' {
    file { "/etc/apache2/sites-enabled/${name}":
      ensure  => $ensure_link,
      target  => "/etc/apache2/sites-available/${name}",
      require => File["/etc/apache2/sites-available/${name}"],
    }
  }

  exec { 'apache-restart':
    command     => '/etc/init.d/apache2 restart',
    refreshonly => true,
  }

  Class['apache'] -> Apache::Vhost[$name]
}
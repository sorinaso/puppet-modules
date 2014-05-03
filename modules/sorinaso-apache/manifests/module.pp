#Agrega un modulo de apache.
define apache::module($package = undef) {
  # Si necesita unpaquete lo instalamos.
  if $package {
    if !defined(Package[$package]) {
      package { $package:
        ensure  => installed
      }
    }
  }

  # Agregamos el modulo.
  exec { "a2enmod-${name}-module":
    creates =>  "/etc/apache2/mods-available/${name}.load",
    command =>  "/usr/bin/sudo a2enmod ${name}",
    require => $package ? {
      undef   => undef,
      default => Package[$package],
    }
  }

  Class['apache'] -> Apache::Module[$name]
}
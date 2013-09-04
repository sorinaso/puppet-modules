# Redmine
class redmine($database_provider, $database_name,
              $database_user, $database_password,
              $notifications_gmail_username,
              $notifications_gmail_password) {
  case $database_provider {
    mysql: {
      include mysql

      # Creo base mysql.
      mysql::database { $database_name:
        user => $database_user,
        password => $database_password,
      }

      # Paquete redmine.
      package { 'redmine':
        ensure => '1.1.3-4',
      }

      # Redmine-mysql.
      package { 'redmine-mysql':
        ensure => '1.1.3-4',
        require => Package['mysql-server'],
      }
    }
    default: { fail("Database provider no conocido.") }
  }

  # Configuro la base de datos.
  file { '/etc/redmine/default/database.yml':
    ensure  => present,
    content => template("redmine/database.yml.erb"),
    owner   => 'www-data',
    mode    => 640,
    require => Package['redmine'],
  }

  # Y mail de notificaciones.
  file { '/etc/redmine/default/email.yml':
    ensure  => present,
    content => template("redmine/email.yml.erb"),
    owner   => 'www-data',
    mode    => 640,
    require => Package['redmine'],
  }
}
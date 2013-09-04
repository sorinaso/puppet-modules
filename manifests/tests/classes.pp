# Base para los servidores en maquinas virtuales.
node vagrant_node {
  # apt-get update pre instalacion de paquetes.
  exec { "apt-update": command => "/usr/bin/apt-get update" }
  Exec["apt-update"] -> Package <| |>

  File {
    owner   => "vagrant",
    group   => "vagrant",
  }

  #sudo apt-get install augeas-tools libaugeas-dev libaugeas-ruby
}
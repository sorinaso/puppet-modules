class admin::ubuntu::apt_autoupdate {
  # apt-get update after packages.
  exec { "apt-update": command => "/usr/bin/apt-get update" }
  Exec["apt-update"] -> Package <| |>
}
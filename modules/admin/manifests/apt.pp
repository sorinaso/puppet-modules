class admin::apt($auto_update = true) {
  include ::apt

  if $auto_update {
    # apt-get update before package instalation.
    @exec { 'admin-apt-update':
      command => "/usr/bin/apt-get update",
      onlyif  => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'",
      tag     => update
    }

    Exec <| tag == update |> -> Package <| |>
  }
}
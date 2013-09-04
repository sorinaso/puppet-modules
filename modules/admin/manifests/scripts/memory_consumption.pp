class admin::scripts::user_memory_consumption(
$path = '/usr/local/bin/user_memory_consumtion',
$ensure = present,
) {
  file { $path:
    ensure  => $ensure,
    content => 'ps -u $1 -o pid,rss,command | awk \'{sum+=$2} END {print sum/1024, "MB"}\'',
    mode    => 744,
  }
}
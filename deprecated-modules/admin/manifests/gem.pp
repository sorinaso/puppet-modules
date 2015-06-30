define admin::gem($ensure = present, $version) {
  gem { $name:
    ensure  => $ensure,
    version => $version,
    source  => "puppet:///modules/admin/gem/${name}-${version}.gem",
  }
}
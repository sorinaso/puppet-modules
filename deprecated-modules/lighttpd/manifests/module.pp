define lighttpd::module($required_packages = undef) {
  include lighttpd::params

  # Module activation.
  ensure_resource(
    "lighttpd::module::activate::${lighttpd::params::os_postfix}",
    $name,
  )
}
class cmmi::params {
  case $::operatingsystem {
    'Ubuntu': {
      $test_cmd     = "/usr/bin/test"
      $tar_cmd      = "/bin/tar"
      $bunzip_cmd   = "/bin/bunzip2"
      $gunzip_cmd   = "/bin/gunzip"
      $rm_cmd       = '/bin/rm'
      $wget_cmd     = '/usr/bin/wget'

      $build_dependencies  = ['build-essential', 'autoconf']
    }
    default: { fail("${::operatinsystem} OS not supported.") }
  }
}
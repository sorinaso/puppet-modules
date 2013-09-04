class sqlite {
  case $operatingsystem {
    ubuntu: {
      package {
        #sqlite
        "sqlite3": ensure => present;
        "libsqlite3-dev": ensure => present;
      }
    }
  }
}
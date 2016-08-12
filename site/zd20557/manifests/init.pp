class zd20557 {
  file { '/tmp/file':
    content => "$::timestamp",
    ensure => present,
  }
}

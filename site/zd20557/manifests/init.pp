class zd20557 {
  file { '/tmp/file':
    content => 'Hello world',
    ensure => present,
  }
}

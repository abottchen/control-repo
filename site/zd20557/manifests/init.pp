class zd20557 {
  file { '/tmp/file':
    content => "${system_uptime[seconds]}",
    ensure => present,
  }
}

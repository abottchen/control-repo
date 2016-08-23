class zd20557 {
  file { "/tmp/${hostname}":
    content => "${system_uptime[seconds]}",
    ensure => present,
  }
}

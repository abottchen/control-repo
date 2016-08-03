class erbtest::ibmim {
  file { '/tmp/file':
    ensure => present,
    content => template('erbtest/file.erb'),
  }
}

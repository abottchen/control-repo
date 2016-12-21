class zd22822 {
  transition { 'testing':
    resource   => Service['ntpd'],
    attributes => { ensure => stopped },
    prior_to   => File['/tmp/testfile']
  }

  file {'/tmp/testfile':
    ensure  => file,
    content => 'testing',
    notify  => Service['ntpd'],
  }

  service { 'ntpd':
    ensure => running,
  }
}

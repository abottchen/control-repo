class zd22822 {
  transition { 'testing':
    resource   => Package['mutt'],
    attributes => { ensure => absent },
    prior_to   => File['/tmp/testfile']
  }

  file {'/tmp/testfile':
    ensure  => file,
    content => 'testing',
    notify  => Package['mutt'],
  }

  package { 'mutt':
    ensure => installed,
  }
}

class zd22822 {
  transition { 'testing':
    resource   => Package['mutt'],
    attributes => { ensure => absent },
    prior_to   => Notify['removing package']
  }

  notify {'removing package': }
  #  file {'/tmp/testfile':
  #    ensure  => file,
  #    content => 'testing',
  #    before  => Package['mutt'],
  #  }

  package { 'mutt':
    ensure => installed,
  }
}

class zd22822 {
  $package='mutt'
  transition { 'testing':
    resource   => Package[$package],
    attributes => { ensure => absent },
    prior_to   => Notify['removing package']
  }

  notify {"removing package ${package}": }
  #  file {'/tmp/testfile':
  #    ensure  => file,
  #    content => 'testing',
  #    before  => Package['mutt'],
  #  }

  package { $package:
    ensure => installed,
  }
}

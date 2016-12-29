class zd22822 {
  $pkg='mutt'

  transition { 'testing':
    resource   => Package[$pkg],
    attributes => { ensure => absent },
    prior_to   => Notify["removing package ${pkg}"]
  }

  notify {"removing package ${pkg}": }

  package { $pkg:
    ensure => installed,
  }
}

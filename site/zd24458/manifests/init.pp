class zd24458 {
  $clusters = ['a','b','c']
  file { '/tmp/test':
    ensure  => file,
    content => template('zd24458/test.txt.erb')
  }
}

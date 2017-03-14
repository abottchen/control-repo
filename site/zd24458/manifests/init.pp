class zd24458 {
  #  $clusters = {'a' => 1,'b' => 2,'c' => 3}
  $query = ["from", "nodes"]
  $clusters = puppetdb_query($query)[0]
  file { '/tmp/test':
    ensure  => file,
    content => template('zd24458/test.txt.erb')
  }
}

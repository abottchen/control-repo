class zd24458 {
  $query = ["from", "nodes"]
  $clusters = puppetdb_query($query)[1]
  file { '/tmp/test':
    ensure  => file,
    content => template('zd24458/test.txt.erb')
  }
}

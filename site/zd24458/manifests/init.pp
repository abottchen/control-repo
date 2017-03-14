class zd24458 {
  $query = ["from", "nodes"]
  $clusters = puppetdb_query($query)
  file { '/tmp/test':
    ensure  => file,
    content => template('zd24458/test.txt.erb')
  }
}

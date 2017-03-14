class zd24458 {
  #  $clusters = {'a' => 1,'b' => 2,'c' => 3}
  $query = ["=","certname", "pe-201642-master.puppetdebug.vlan"]
  $clusters = puppetdb_query($query)
  file { '/tmp/test':
    ensure  => file,
    content => template('zd24458/test.txt.erb')
  }
}

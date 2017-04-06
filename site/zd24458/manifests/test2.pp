class zd24458::test2 {
  $nodes =  {
    "foo.example.com" => {
      "ipaddress"     => "192.168.0.2",
      "osfamily"      => "Redhat"
    },
    "bar.example.com" => {
      "ipaddress"     => "192.168.0.3",
      "osfamily"      => "Debian"
    }
  }

  file { '/tmp/test':
    ensure  => file,
    content => template('zd24458/test2.txt.erb')
  }
}

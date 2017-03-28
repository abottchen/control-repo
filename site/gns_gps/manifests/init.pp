class gns_gps {
  file {'/tmp/test': 
    ensure  => file,
    content => "Don't restart",
    notify  => Service['ntpd'],
  }

  service {'ntpd':
    ensure   => running,
    schedule => 'maint window',
  }

  schedule {'maint window':
    range => '1-3',
    period => 'daily',
    repeat => 1,
  }
}

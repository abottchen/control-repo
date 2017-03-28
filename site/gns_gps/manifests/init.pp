class gns_gps {
  file {'/tmp/test': 
    ensure  => file,
    content => "Don't restart",
    notify  => Service['ntpd'],
    schedule => 'maint window',
  }

  service {'ntpd':
    ensure   => running,
  }

  schedule {'maint window':
    range => '13 - 15',
    #    period => 'daily',
    #    repeat => 1,
  }
}

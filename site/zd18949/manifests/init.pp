class zd18949 {
  schedule { 'maintenance_window':
    range   => '17:00 - 18:00',
    repeat  => 1,
    weekday => 'Monday',
  }

  exec { 'patchall':
    command  => '/bin/true',
    schedule => 'maintenance_window',
    notify   => Reboot['after_run'],
    timeout  => 3600,
  }

  reboot { 'after_run':
    apply   => finished,
    noop    => true,
    message => 'Rebooting to apply patches.'
  }
}

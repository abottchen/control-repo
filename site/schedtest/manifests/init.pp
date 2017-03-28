include test

class test {
  notify { 'within window':
    schedule => 'window',
  }

  schedule { 'window':
    range  => '13 - 17',
    period => daily,
    repeat => 1,
  }
}

class zd22822 {
  transition { 'testing':
    resource   => Notify['test1'],
    attributes => { message        => 'changed test1' },
    prior_to   => Notify['test2']
  }

  notify {'test1': before => Notify['test2']}

  notify {'test2': }
}

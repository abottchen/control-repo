class puppet_splay {
  ini_setting { 'enable splay':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'agent',
    setting => 'splay',
    value   => 'true',
  }
}

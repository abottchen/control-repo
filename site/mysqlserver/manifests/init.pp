class mysqlserver {
  class { '::mysql::server':
    root_password           => 'puppetlabs',
    remove_default_accounts => true,
  }
}

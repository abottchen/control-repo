class zd23977 {
  class { '::mysql::server':
    root_password           => 'strongpassword',
    remove_default_accounts => true,
  }
  #  
  #  mysql_user { 'adam@127.0.0.1':
  #    ensure                   => 'present',
  #    max_connections_per_hour => '0',
  #    max_queries_per_hour     => '0',
  #    max_updates_per_hour     => '0',
  #    max_user_connections     => '0',
  #  }
  mysql::db { 'mydb':
    user        => 'myuser',
    password   => 'mypass',
    host    => 'localhost',
    grant => ['SELECT', 'UPDATE'],
  }
}

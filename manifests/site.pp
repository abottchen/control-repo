## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
#http://docs.puppetlabs.com/pe/latest/release_notes.html#filebucket-resource-no-longer-created-by-default
#File { backup => false }
if $trusted['certname'] == 'pe-201611-master-lei.puppetdebug.vlan' {
  notify {'setting up master filebucket': }
  filebucket { 'main': }
} elsif $trusted['certname'] == 'pe-201611-cm-lei.puppetdebug.vlan' {
  notify {'setting up compile master filebucket': }
  filebucket { 'main': 
    path   => false,
    server => 'pe-201611-master-lei.puppetdebug.vlan',
  }
} elsif $trusted['certname'] == 'p6ip8m87picuyg6.delivery.puppetlabs.net' {
  notify {'setting up agent filebucket': }
  filebucket { 'main': 
    path   => false,
    server => 'pe-201611-master-lei.puppetdebug.vlan',
  }
}

case $trusted['certname'] {
  'pe-201611-master-lei.puppetdebug.vlan':    { File { backup => 'main' } }
  'pe-201611-cm-lei.puppetdebug.vlan':        { File { backup => 'main' } }
  'p6ip8m87picuyg6.delivery.puppetlabs.net':  { File { backup => 'main' } }
  default:                                    { File { backup => false } }
}

node default {
}

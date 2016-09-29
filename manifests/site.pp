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
File { backup => false }

node /ivh1djpixluvddk*/ {
  package { '/tmp/gatekeeper-1.1.0-1.x86_64.rpm':
    ensure => present,
  } ->
  service {'gatekeeper':
    ensure         => running,
    enable        => true,
    #    hasstatus => false,
    #status        => 'cat /var/run/gatekeeper.pid',
  }
}

node default {
  include zd21049
}

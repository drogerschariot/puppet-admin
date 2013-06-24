puppet-admin
============

Do multiple admin tasks to your puppet clients. Tested using [Puppetry](https://github.com/drogerschariot/Puppetry). 


Tested:
* Ubuntu 12.04
* Debian 7
* CentOS 6.4

Functions
---------

#### admin::sudoer ####

Add multiple sudoers.

<pre>
<code>
admin::sudoer { 'foo':
  ssh_key => 'somesshpubkey', # Optional 
  password => 'somesha512hash', # Make sure hash is in single quotes!
  no_sudopass => true, # Optional, when you run sudo, you will not be prompted for a password
  uid => '555', # Optional, but should be defined
  shell => '/bin/bash', # Optional
  home => '/home/foo', # Optional
  groups => ["users","admin"], # Array of groups
}
</code>
</pre>

#### admin::user ####

Add multiple users.

<pre>
<code>
admin::user { 'foo':
  ssh_key => 'somesshpubkey', # Optional 
  password => 'somesha512hash', # Make sure hash is in single quotes!
  uid => '555', # Optional, but should be defined
  shell => '/bin/bash', # Optional
  home => '/home/foo', # Optional
  groups => ["users","admin"], # Array of groups
}
</code>
</pre>

#### admin::cacti ####

Setup snmp on client to communicate to a [Cacti](http://www.cacti.net/) server.

<pre>
<code>
class { 'admin::cacti':
   comm_name => 'public', #snmp community name
   comm_ip => '192.168.1.0/24', #IP addess or range to allow snmp traffic
}
</code>
</pre>

#### admin::nagios-plugins ####

Installs [nagios plugins](http://nagiosplugins.org/) (and [NRPE](http://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE--2D-Nagios-Remote-Plugin-Executor/details)) on client.

<pre>
<code>
class { 'admin::cacti':
   root_path => '/opt/nagios' #root path to install nagios plugins
   nrpe => true #If you want nrpe installed
   ssllib_path => '/usr/lib/x86_64-linux-gnu/' #The apth to the SSL library
   nagios_host => "192.168.100.1" #Path to nagios host. 
}
</code>
</pre>


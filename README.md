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

# sudoer
#-------
# Creates a sudoer
# 
# Params
#-------
#	[username] String
#		The username of the sudoer to be created. The  $title will
#		be asigned to the $username
#
#	[password] String
#		Must be SHA512 hash. You can do this by running the 
#		'mkpasswd -m sha-512' command.
#
#	[ssh_key] String, Optional
#		SSH public key. If defined, the public key will be installed in
#		$home/.ssh/authorized_keys.
#
#	[no_sudopass] Boolean, Optional
#		If set to true, you will not have to type a password when
#		you run `sudo <command>
#	 
#	[uid] Int, Optional (Kinda)
#		The uid that will be assigned to the user. The default is 600
#		but really should be defined.
#
#	[shell] String, Optional
#		Path to the shell you would like the user to use, default is bash
#
#	[home] String, Optional
#		Path to home directory for user, default is /home/<username>
#
#	[groups] Array[Strings], Optional
#		An array of groups the user will belong too.
#
#	[sudo_template] Template
#		The template to use for the sudoer that will be saved to 
#		/etc/sudoer.d . You do not need to supply your own template,
#		but can if you want.
# Usage
#------
# admin::sudoer { "foo"
#	password	=> "somesha512hash!",
#	groups		=> [ "admins", "users"],
#	no_sudopass	=> true,
#	
# }


define admin::sudoer ( 
	$username = $title, 
	$ssh_key = undef, 
	$password = undef, 
	$no_sudopass = false,
	$uid = '600', # this really should be defined 
	$shell = '/bin/bash',
	$home = "/home/${username}",
	$groups = undef){
	

	### define which template to use ###
	case $operatingsystem {
		'Ubuntu': {
			$sudo_template = 'sudo-ubuntu.erb'
		}
		'Debian': {
			$sudo_template = 'sudo-debian.erb'
		}
		'CentOS': {
			$sudo_template = 'sudo-centos.erb'
		}
		default: {
			fail("Cannot match your environment!")
		}
	}

	### Check Variables ###

	if ($username == undef) or ($password == undef){
		fail("Username and/or password are not defined!")
	}

	### Create Sudoer ###

	user { "${username}":
		comment 	=> "${username} is a sudoer",
		home 		=> $home,
		ensure 		=> present,
		shell 		=> $shell,
		uid 		=> $uid,
		gid			=> $username,
		groups		=> $groups,
		managehome	=> true,
		password	=> $password,
		require 	=> Group[ $username ],
	}

	group { "${username}":
		ensure 	=> present,
	}

	file { "/home/${username}/.ssh":
		ensure	=> directory,
		owner	=> $username,
		group 	=> $username,
		mode	=> 700,
		require	=> User[ $username ],
	}

	file { "/etc/sudoers.d/${username}":
		ensure 	=> file,
		content	=> template("admin/${sudo_template}"),
		mode	=> 0640,
		owner	=> 'root',
		group   => 'root',
	}

	file { "/home/${username}/.ssh/authorized_keys":
		ensure 	=> file,
		owner	=> $username,
		group 	=> $username,
		mode	=> 600,
		require	=> File[ "/home/${username}/.ssh" ],
		content	=> $ssh_key,
	}
}

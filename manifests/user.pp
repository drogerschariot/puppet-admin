# admin::user
#-------
# Creates a user
# 
# Params
#-------
#	[username] String
#		The username of the sudoer to be created. The  $title will
#		be asigned to the $username
#
#	[password] String
#		Must be SHA512 hash. You can do this by running the 
#		'mkpasswd -m sha-512' command. Also make sure the password
#		string is in single quotes!
#
#	[ssh_key] String, Optional
#		SSH public key. If defined, the public key will be installed in
#		$home/.ssh/authorized_keys.
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
# Usage
#------
# admin::user { "foo"
#	password	=> 'somesha512hash!',
#	groups		=> [ "admins", "users"],
#	
# }


define admin::user ( 
	$username = $title, 
	$ssh_key = undef, 
	$password = undef, 
	$uid = '600', # this really should be defined 
	$shell = '/bin/bash',
	$home = "/home/${username}",
	$groups = undef){


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

	file { "${home}/.ssh":
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

	file { "${home}/.ssh/authorized_keys":
		ensure 	=> file,
		owner	=> $username,
		group 	=> $username,
		mode	=> 600,
		require	=> File[ "${home}/.ssh" ],
		content	=> $ssh_key,
	}
}

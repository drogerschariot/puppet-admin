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


define admin::systemuser ( 
	$username = $title, 
	$ssh_key = undef, 
	$password = undef, 
	$uid = undef, # this really should be defined 
	$shell = undef,
	$home = undef,
	$groups = undef,
	$system = false,
	$mang_home = false,
	$manages_passwords = false, 
	){


	### Check Variables ###

	if ($username == undef){
		fail("Username and/or password are not defined!")
	}

	### Create user ###

	user { "${username}":
		home 		=> $home,
		ensure 		=> present,
		shell 		=> $shell,
		uid 		=> $uid,
		managehome	=> $mang_home,
		password	=> $password,
		system		=> true,
	}


}

# Class: ${username}
# 
# Creates sudoer user ${username} with public keys

define add_sudoer ( $username = $title, 
					$ssh_key = undef, 
					$password = undef, 
					$no_sudopass = false,
					$uid = undef, 
					$bash = '/bin/bash',
					$home = "/home/${username}" ) {

	case $operatingsystem {
		Ubuntu: {
			$groups = [ "adm", "cdrom", "sudo", "dip", "lpadmin", "sambashare" ]
			$sudo_temp = 'sudo-ubuntu.erb'
		}
		Debian: {
			$groups = [ "cdrom", "sudo" ]
			$sudo_temp = 'sudo-debian.erb'
		}
		CentOS: {
			$groups = [ "wheel" ]
			$sudo_temp = 'sudo-centos.erb'
		}
		default: {
			$groups = undef
		}
	}

	user { "${username}":
		comment 	=> "${username} sudoer",
		home 		=> $home,
		ensure 		=> present,
		shell 		=> $bash,
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
		content	=> template("add_sudoer/${sudo_temp}"),
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
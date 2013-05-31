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
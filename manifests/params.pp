class admin::params {

	# Get some distro specific names and packages. 
	case $operatingsystem {
	    'Ubuntu', 'Debian': {
            $vim = "vim"
            exec { "apt_update":
                command         => "apt-get update",
                path            => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
                before          => Package[ 'vim', 'git', 'puppet' ],
            }
	    }
	    'CentOS', 'Fedora', 'RedHat': {
            $vim = "vim-common"
	    }
	}


}

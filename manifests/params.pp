class admin::params {

	case $operatingsystem {
	    'Ubuntu', 'Debian': {
               $vim = "vim"
	    }
	    'CentOS', 'Fedora', 'RedHat': {
               $vim = "vim-common"
	    }
	}


}

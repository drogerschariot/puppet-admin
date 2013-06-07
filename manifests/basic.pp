# admin::basic
#-------
# Installs basic "essentials" for a server.
# 
# Params
#-------
#	None.
#
# Usage
#------
#	include admin::basic

class admin::basic {
	
	include admin::params

	package { "$vim":
		ensure		=> present,
		}
	}
}
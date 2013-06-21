# Class: admin::cacti
#
#
class admin::cacti {

	case $osfamily {
			"Debian": {
				$snmpd = "snmpd"
			}
			"RedHat": {
				$snmpd = "net-snmp"
			}
		}	

	package { $snmpd:
		ensure => installed,
	}

	file { "/etc/snmp/snmpd.conf":
		ensure 		=> file,
		owner		=> 'root',
		group 		=> 'root',
		mode		=> 750,
		source		=> 'puppet:///admin/snmp.conf',
	}

	file { "/etc/default/snmpd":
		ensure 		=> file,
		owner		=> 'root',
		group 		=> 'root',
		mode		=> 744,
		source		=> 'puppet:///admin/default_snmp',
	}

	service { "snmpd":
	    enable 		=> true,
		ensure 		=> running,
		hasrestart 	=> true,
		hasstatus 	=> true,
		require 	=> Package[ $snmpd ],
		subscribe	=> [ 
			File[ "/etc/snmp/snmpd.conf" ],
			File[ "/etc/default/snmpd" ],
		],
	}
}
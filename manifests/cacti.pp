# Class: admin::cacti
#
#
class admin::cacti(
	$comm_name = 'chariot',
	$comm_ip = '192.168.117.0/24',
	) {

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
		content		=> template('admin/snmp.conf.erb'),
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
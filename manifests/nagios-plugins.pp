# Class: admin::nagios-plugins
#
#
class admin::nagios-plugins(
	$root_path = '/opt/nagios',
	$nrpe = true,
	$ssllib_path = '/usr/lib/x86_64-linux-gnu/',
	$nagios_host = "192.168.117.39"
	) {
	
	case $osfamily {
		"RedHat": { 
			$libssl = "openssl-devel"
		}
		default: {
			$libssl = "libssl-dev"
		}
	}

	Exec {
		path		=> "/bin:/usr/bin:/sbin:/usr/sbin",
	}

	admin::systemuser { "nagios": }

	exec { "untar_nagiosplugins":
		command		=> "tar -zxf nagios-plugins-1.4.16.tar.gz",
		cwd			=> "/tmp",
		require		=> File[ "nagiosplugins_tarfile" ],
		creates		=> "/tmp/nagios-plugins-1.4.16",

	}
	file { "nagiosplugins_tarfile":
		path 		=> "/tmp/nagios-plugins-1.4.16.tar.gz",
		ensure		=> present,
		source		=> "puppet:///modules/admin/nagios-plugins-1.4.16.tar.gz",
	}

	package { [ $libssl, "xinetd" ]:
		ensure => installed,
	}

	exec { "compile_nagiosplugins":
		command 	=> "/tmp/nagios-plugins-1.4.16/configure --prefix=${root_path} --with-nagios-user=nagios --with-nagios-group=nagios && make && make install",
		cwd			=> "/tmp/nagios-plugins-1.4.16",
		require 	=> [
			Exec[ "untar_nagiosplugins" ],
			Package[ $libssl ],
			Package[ "xinetd" ],
			Admin::Systemuser[ "nagios" ],
		],
		creates		=> $root_path,
	}

	if $nrpe {
		exec { "untar_nrpe":
			command		=> "tar -zxf nrpe-2.14.tar.gz",
			cwd			=> "/tmp",
			require		=> File[ "nrpe_tarfile" ],
			creates		=> "/tmp/nrpe-2.14",
		}

		file { "nrpe_tarfile":
			path 		=> "/tmp/nrpe-2.14.tar.gz",
			ensure		=> present,
			source		=> "puppet:///modules/admin/nrpe-2.14.tar.gz",
		}

		exec { "compile_nrpe":
			command 	=> "/tmp/nrpe-2.14/configure --prefix=${root_path} --with-ssl-lib=${ssllib_path} && make all && make install-plugin && make install-daemon && make install-daemon-config && make install-xinetd",
			cwd			=> "/tmp/nrpe-2.14",
			require 	=> [
				Exec[ "compile_nagiosplugins" ],
			],
			creates		=> "${root_path}/bin/nrpe",
			notify		=> Exec[ "nrpe_services" ],
		}
	}

	file { "/etc/xinetd.d/nrpe":
		ensure 		=> file,
		content		=> template("admin/nrpe.erb"),
		require		=> [
			Package[ "xinetd" ], 
			Exec[ "compile_nrpe" ], 
		],
	}

	exec { "nrpe_services":
			command => "echo 'nrpe            5666/tcp                        # NRPE' >> /etc/services",
			refreshonly => true,
	}

	service { "xinetd":
	    enable 		=> true,
		ensure 		=> running,
		hasrestart 	=> true,
		hasstatus 	=> true,
		require 	=> Package["xinetd"],
		subscribe	=> Exec[ "nrpe_services" ],
	}

	exec { "chown -R nagios:nagios ${root_path}":
		subscribe	=> [ Exec[ "compile_nagiosplugins" ], Exec[ "compile_nrpe" ] ],
		refreshonly	=> true,
	}

}
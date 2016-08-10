class base (
	$timezone         = undef,
) {

	include base::services
	include base::execs
	include base::sshkeysroot
  include base::packages
  validate_string($timezone)

	realize Exec['yum_clean_all']
	realize Service['iptables']
	realize Service['crond']

# resolv.conf

	file { "link_localtime_to_$timezone":
		path    => '/etc/localtime',
		ensure  => 'link',
		target  => "/usr/share/zoneinfo/$timezone",
		force   => true,
	}

	class { '::ntp':
		servers => [ '0.centos.pool.ntp.org', '1.centos.pool.ntp.org','2.centos.pool.ntp.org'],
	}


	# Update libs if required
	file {  "/var/lib/rpm/Packages":
		owner   => root,
		group   => root,
		notify  => Exec["update_ldconfig"],
		audit   => "content",
	}
	exec { 'update_ldconfig':
		command => "/sbin/ldconfig",
		refreshonly => true,
	}

}

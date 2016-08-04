class base (
	$timezone         = undef,
	$default_packages = undef,
) {

	include base::services
	include base::execs
	include base::sshkeysroot
  include base::packages
  validate_string($timezone)
  validate_array($default_packages)

	ensure_packages($default_packages)

	realize Exec['yum_clean_all']
	realize Service['iptables']
	realize Service['crond']

# resolv.conf

	package {'epel-release':
		name    => "epel-release",
		ensure  => latest,
		notify  => Exec['yum_clean_all'],
	}

	file { "link_localtime_to_$timezone":
		path    => '/etc/localtime',
		ensure  => 'link',
		target  => "/usr/share/zoneinfo/$timezone",
		force   => true,
	}

	class { '::ntp':
		servers => [ '0.centos.pool.ntp.org', '1.centos.pool.ntp.org','2.centos.pool.ntp.org','127.127.1.0'],
		restrict => $ntp::restrict,
		driftfile => '/var/lib/ntp/drift',
		keys_enable => true,
		keys_file => '/etc/ntp/keys',
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

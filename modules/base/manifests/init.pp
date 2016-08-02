class base (
	$timezone = $::base::params::timezone,
	$crond_status = $::base::params::crond_status,
	$iptables = $::base::params::iptables,
	$default_packages = $::base::params::default_packages,
) inherits base::params {

	include base::services
	include base::execs
	include base::params
	include base::sshkeysroot

	ensure_packages($default_packages)

	realize Exec['yum_clean_all']
	realize Service['iptables']
	realize Service['crond']


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
		restrict => $ntp_restrict,
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

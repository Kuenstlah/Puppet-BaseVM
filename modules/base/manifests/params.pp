class base::params {

	# Configure this settings
	$timezone	= 'Europe/Berlin'
	$iptables	= false
	$crond_status	= true

	case $operatingsystemmajrelease {
		'5':    {       $default_packages = [ "redhat-lsb", "bash", "screen", "strace", "sysstat", "vim-enhanced", "tmpwatch", "perl-Config-General", "perl-DBD-MySQL", "bind-utils", "mlocate", "mc", "git" ]
	}
		'6':    {       $default_packages = [ "redhat-lsb", "bash", "screen", "strace", "sysstat", "vim-enhanced", "tmpwatch", "perl-Config-General", "perl-DBD-MySQL", "bind-utils", "mlocate", "mc", "git"]
	}
		'7':    {   $default_packages = [ "redhat-lsb", "bash", "screen", "strace", "sysstat", "vim-enhanced", "tmpwatch", "perl-Config-General", "perl-DBD-MySQL", "bind-utils", "mlocate", "mc", "git"]
	}
	}

}

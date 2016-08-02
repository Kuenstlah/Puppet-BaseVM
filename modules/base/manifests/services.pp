class base::services (
	$iptables = $::base::params::iptables,
	$crond	  = $::base::params::crond
) {
	if ($iptables) {
		@service { "iptables":
			ensure => 'running',
			enable => true,
		}
	}
	else {
		@service { "iptables":
			ensure => 'stopped',
			enable => false,
		}
	}
        if ($crond) {
		@service { "crond":
                        ensure => 'running',
                        enable => true,
		}
	} else {
		@service { "crond":
			ensure => 'stopped',
			enable => false,
		}

	}

}

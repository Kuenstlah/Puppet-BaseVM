class base::services (
	$iptables = $::base::params::iptables,
	$crond_status = $::base::params::crond_status
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

    @service { "disable_sendmail":
        ensure  => stopped,
        enable  => false,
    }

    @service { "disable_iscsid":
        ensure  => stopped,
        enable  => false,
    }

    @service { "enable_crond": ensure => $crond_status }

    @service { 'enable_snmpd':
        name      => 'snmpd',
        ensure    => running,
        enable    => true,
    }

}

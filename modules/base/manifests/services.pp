class base::services (
	$iptables = undef,
	$crond	  = undef
) {

  validate_bool($iptables)
  validate_bool($crond)

  # iptables
  $iptables_ensure = $iptables ? {
    false => 'stopped',
    true  => 'running',
  }
  @service { "iptables":
    ensure => $iptables_ensure,
    enable => $iptables,
  }

  # cron
  $crond_ensure = $crond ? {
    false => 'stopped',
    true  => 'running',
  }
  @service { "crond":
    ensure => $crond_ensure,
    enable => $crond,
  }


}

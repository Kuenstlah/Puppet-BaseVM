class base::sshkeysroot (
  $pubkeys = undef,
) {
  validate_hash($pubkeys) 
	file { '/root/.ssh/authorized_keys':
		ensure  => "present",
		owner   => 'root',
		group   => 'root',
		mode    => '600',
		require => File['/root/.ssh/'],
	}

	file { '/root/.ssh/':
		ensure  => "directory",
		owner   => 'root',
		group   => 'root',
		mode    => '700',
	}

	$defaults_sshkeysroot = {
		ensure  => present,
		path    => "/root/.ssh/authorized_keys",
		require => [File['/root/.ssh/authorized_keys'],File['/root/.ssh/']],	
	}

  create_resources(file_line, $pubkeys, $defaults_sshkeysroot)
}

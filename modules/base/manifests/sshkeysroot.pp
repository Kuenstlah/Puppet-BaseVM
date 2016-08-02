class base::sshkeysroot {
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

        $sshkeys = {
                'sshkey_kkuenstler' => { line => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAwWBz4HAf/ovq0Q8txxiLDVkgEykAS6jOldfoFvV5iQ+DOOLmMo/T+/dDxbJhgR4ow/1RXTstLmdM/00686d8ErUHXtnZ9jyDlgLJIdyXyV8adD+0iXhmvUx2+ZqlP4wNBfg6B56Erx8MQn9Z7E6ySDvCqxLgOKObgw7wJRsuoGxYyvO4xfOyNpvJelVfVldgWbH44e5+qYyNKrVjcN7Cbdln/Y2JF5qjzAC4MIWksiPVihw5rL3MDOHqd/Qf6JmCWz2uF2OYBr163rLVsNkN4jis94zA61iWNGffqHHMZ3xNidkq0+GkfVHYoNHiVUt5tWaQhxIEAluni+s0gf3XRQ== rsa-key-20160801-kuenstler' },
        }
        create_resources(file_line, $sshkeys, $defaults_sshkeysroot)

}

class base (
	$vm_shared_folder = undef,
	$timezone         = undef,
	$ntp_servers			= undef,	
) {
	validate_string($timezone)
	validate_array($ntp_servers)
	include base::services
	include base::execs
	include base::sshkeysroot
	include base::packages
	include base::files

	realize Exec['yum_clean_all']
	realize File['symlink_rootpuppet_to_etc_puppet']
	
	if ($vm_shared_folder != 'undef') {
		file { 'symlink_/root/vm_to_shared-folder':
			ensure => 'link',
			path   => '/root/vm',
			target => "${vm_shared_folder}",
		}
	}

	# Service
	realize Service['iptables']
	realize Service['crond']
	
	# Alias
	realize File_line['alias_vim']
	realize File_line['alias_confluence_cdhome']
	realize File_line['alias_confluence_cdinstall']
	realize File_line['alias_confluence_log']
	realize File_line['alias_jira_checklock']
	realize File_line['alias_jira_cdhome']
	realize File_line['alias_jira_cdinstall']
	realize File_line['alias_jira_log']
	realize File_line['alias_puppet_run']
	realize File_line['alias_puppet_lookup']

	# Timezone
	realize File["link_localtime_to_$timezone"]
	class { '::ntp':
		servers => $ntp_servers,
	}


	# Update libs if an rpm has been installed
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

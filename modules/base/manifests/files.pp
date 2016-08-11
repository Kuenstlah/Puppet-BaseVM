class base::files (
  $puppet_homedir = undef,
) {
	validate_string($puppet_homedir)

	
	@file { "link_localtime_to_$base::timezone":
		path   => '/etc/localtime',
		ensure => 'link',
		target => "/usr/share/zoneinfo/$base::timezone",
		force  => true,
	}
    @file_line { 'alias_vim':
        ensure  => present,
        path    => "/root/.bashrc",
        line    => "alias vi='vim -p'",
        match  => '^alias vi='
    }
    @file_line { 'alias_confluence_cdhome':
        ensure  => present,
        path    => "/root/.bashrc",
        line    => "alias confluence_cdhome='cd /var/atlassian/application-data/confluence'",
        match  => '^alias confluence_cdhome='
    }
    @file_line { 'alias_confluence_cdinstall':
        ensure  => present,
        path    => "/root/.bashrc",
        line    => "alias confluence_cdinstall='cd /opt/atlassian/confluence'",
        match  => '^alias confluence_cdinstall='
    }
    @file_line { 'alias_confluence_log':
        ensure => present,
        path   => "/root/.bashrc",
        line   => "alias confluence_log='tail -f /opt/atlassian/confluence/logs/catalina.out /var/atlassian/application-data/confluence/logs/atlassian-confluence.log'",
        match  => '^alias confluence_log='
    }
    @file_line { 'alias_jira_checklock':
        ensure  => present,
        path    => "/root/.bashrc",
        line    => "alias jira_checklock='ls /var/atlassian/application-data/jira/.jira-home.lock'",
        match  => '^alias jira_checklock='
    }
    @file_line { 'alias_jira_cdhome':
        ensure  => present,
        path    => "/root/.bashrc",
        line    => "alias jira_cdhome='cd /var/atlassian/application-data/jira/'",
        match  => '^alias jira_cdhome='
    }
    @file_line { 'alias_jira_cdinstall':
        ensure  => present,
        path    => "/root/.bashrc",
        line    => "alias jira_cdinstall='cd /opt/atlassian/jira/'",
        match  => '^alias jira_cdinstall='
    }
    @file_line { 'alias_jira_log':
        ensure  => present,
        path    => "/root/.bashrc",
        line    => "alias jira_log='tail -f /opt/atlassian/jira/logs/catalina.out /var/atlassian/application-data/jira/log/atlassian-jira.log'",
        match  => '^alias jira_log='
    }
    @file_line { 'alias_puppet_run':
        ensure  => present,
        path    => "/root/.bashrc",
        line    => "alias puppet_run='puppet apply ${puppet_homedir}/code/environments/production/manifests/'",
        match  => '^alias puppet_run='
    }
    @file_line { 'alias_puppet_lookup':
        ensure  => present,
        path    => "/root/.bashrc",
        line    => "alias puppet_lookup='puppet lookup --explain --environmentpath environments'",
        match  => '^alias puppet_lookup='
    }

    @file { 'symlink_rootpuppet_to_etc_puppet':
        path    => '/root/puppet',
        ensure  => 'link',
        target  => "${puppet_homedir}/code/environments/production/",
    }

}

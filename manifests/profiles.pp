class profile::base {
  include base
}
class profile::mysql_server {
  include mysql::server
}
class profile::mysql_client {
  include mysql::client
}
class profile::jira {
  include profile::base
  include profile::mysql_server
  include profile::mysql_client

  $connector_version="5.1.39"
  exec { 'jira-mysql-connector-java':
    path    => ['/usr/bin', '/usr/sbin',],
    command => "wget -O /tmp/mysql-connector-java-${connector_version}.tar.gz http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${connector_version}.tar.gz",
    creates => "/opt/atlassian/jira/lib/mysql-connector-java-${connector_version}-bin.jar",
    notify => Exec['unzip_jira-mysql-connector-java'],
  }

  exec {'unzip_jira-mysql-connector-java':
    path    => ['/usr/bin', '/usr/sbin', '/bin/'],
    command => "tar xfz /tmp/mysql-connector-java-${connector_version}.tar.gz -C /tmp/;mv /tmp/mysql-connector-java-${connector_version}/mysql-connector-java-${connector_version}-bin.jar /opt/atlassian/jira/lib/;rm -rf /tmp/mysql-connector-java-${connector_version}*",
    refreshonly => true,
  }


  file { '/root/jira-home':
    ensure => 'link',
    target => '/var/atlassian/application-data/jira',
  }
  file_line { 'Increase timeout for loading plugins':
    path => '/opt/atlassian/jira/bin/setenv.sh',
    line => 'JVM_SUPPORT_RECOMMENDED_ARGS="-Datlassian.plugins.enable.wait=300"',
    match   => "^JVM_SUPPORT_RECOMMENDED_ARGS=.*$",
  }
}

class profile::base {
  include base
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

}

# Puppet-BaseVM

Installs puppet server+agent and configures specific base settings for a local server.


# Tasks
- Adds and configures sshkey for root (add your pub.key)
- Checks services: iptables;crond
- Sets timezone


# Configuration
- Run 'setup.sh' to install and setup Puppet v4
- Rename 'hieradata/nodes/vm1.test.local.yaml' to the FQDN of your machine
- Check 'hieradata/common.yaml' since it is used for global configuration. Once a .yaml in hieradata/nodes/ missess a parameter, common.yaml will be used.
- Run puppet in a local instance: 'puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp'


# Compatibility
- (CentOS 5)
- CentOS 6
- (CentOS 7)

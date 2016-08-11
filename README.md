# Puppet-BaseVM

Installs puppet server+agent and configures specific base settings for a local server.
Does <b>NOT</b> run a puppet server.

# Tasks
- Adds and configures sshkey for root (add your pub.key)
- Checks services: iptables;crond
- Sets timezone


# Configuration
- Run 'setup.sh' to install and setup Puppet v4
- Use '/etc/puppetlabs/code/environment/production/' as default path.
- Rename 'hieradata/nodes/vm1.test.local.yaml' to the FQDN of your machine. Once Puppet has been installed, the FQDN which Puppet receives can be checked with 'facter -p fqdn'
- Check 'hieradata/common.yaml' since it is used for global configuration. Once a .yaml in hieradata/nodes/ misses a parameter, common.yaml will be used.
- Run puppet in a local instance: 'puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp'


# Compatibility
- (CentOS 5)
- CentOS 6
- (CentOS 7)

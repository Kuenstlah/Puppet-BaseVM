# Puppet-BaseVM

Installs puppet and configures specific base settings.
This is mainly for test servers.

# Tasks
- Disables iptables
- Adds and configures sshkey for root (add your pub.key)
- Runs crond
- Sets timezone to 'Europe/Berlin' 


# Configuration
Modify file 'modules/base/manifests/params.pp' as you need.
Run 'setup.sh' afterwards and follow its instructions.


# Compatible to
- (CentOS 5)
- CentOS 6
- (CentOS 7)

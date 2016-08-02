# Puppet-BaseVM

Installs puppet and configures specific base settings which are required for a test vm.

By default:
- Disables iptables
- Adds and configures sshkey for root (add your pub.key)
- Runs crond
- Sets Timezone to 'Europe/Berlin' 


# Configuration
Modify file 'modules/base/manifests/params.pp' as you need.
Run 'setup.sh' afterwards and follow its instructions.


# Compatible to
- (CentOS 5)
- CentOS 6
- (CentOS 7)

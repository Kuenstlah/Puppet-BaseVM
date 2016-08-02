#!/bin/bash

rpm -qa puppet|grep puppet >> /dev/null


echo "####### Installation ######"
grep vim .bashrc >> /dev/null
if [[ $? == 1 ]];then
        echo 'alias vi="vim -p"' >> ~/.bashrc
fi

if [[ $? == 0 ]];then
	echo "Puppet already installed, skipping installation"
else
	rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
	yum install puppet-server git vim-enhanced
	mkdir /etc/puppet/hieradata
	#touch /etc/puppet/hiera.yml
	puppet module install puppetlabs-stdlib
	puppet module install puppetlabs-ntp
fi

rm -rf ~/test/
git clone https://github.com/Kuenstlah/Puppet-Base.git ~/test
exit


echo "####### Testing puppet run ######"
puppet apply /etc/puppet/manifests/site.pp --noop --detailed-exitcodes

if [[ $? == 0 ]];then
	echo "####### Running puppet######"
	puppet apply /etc/puppet/manifests/site.pp
else
	echo "####### Something went wrong, please check and re-run this script #######"
fi

echo "####### Finished ######"
#echo -e "[global]
#server string = Samba %v on (%L)
#workgroup = WORKGROUP
#security = user
#encrypt passwords = yes
#interfaces = eth0
#bind interfaces only = yes
#hosts allow = 192.168.178. localhost
#
#[Temp]
#comment = Tmp
#path = /tmp/
#read only = no
#writeable = yes
#guest ok  = yes
#" > /tmp/smb.conf

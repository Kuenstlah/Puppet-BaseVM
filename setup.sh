#!/bin/bash

tmp_path="/tmp/"
tmp_puppet="$tmp_path/PuppetBase"
git_repo="git@github.com:Kuenstlah/Puppet-BaseVM.git"
# Write alias? 1 = yes
alias=1

grep vim ~/.bashrc >> /dev/null
if [[ $? != 0 ]] && [[ $alias == 1 ]];then
	echo "### Creating some nice alias..."
        echo 'alias vi="vim -p"' >> ~/.bashrc
fi

rpm -qa puppet|grep puppet >> /dev/null
# 0 = rpm is already installed
if [[ $? != 0 ]];then
	echo "### Installing puppet..."
	rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm > /dev/null 2>&1
	yum install -y puppet-server git vim-enhanced > /dev/null 2>&1
else
        echo "### Puppet is already installed, skipping its installation"
fi

# Check if targeted directorys are empty, delete if yes
if [[ -d "/etc/puppet/modules/" ]];then
	rmdir /etc/puppet/modules/ > /dev/null 2>&1
	if [[ $? != 0 ]];then
		echo "### ERROR: /etc/puppet/modules/ is not empty";exit
	fi
	rmdir /etc/puppet/manifests/ > /dev/null 2>&1
	if [[ $? != 0 ]];then
		echo "### ERROR: /etc/puppet/manifests is not empty";exit
	fi
fi

# Clone git repositorx with required modules
echo "### Cloning Git repo into /etc/puppet/"
if [[ -d $tmp_puppet ]];then 
	rm -rf $tmp_puppet
fi
git clone $git_repo $tmp_puppet > /dev/null 2>&1
if [[ $? != 0 ]];then
	echo "### ERROR: Can't clone git repository";exit
else
	mv $tmp_puppet/{modules,manifests} /etc/puppet/
	echo "# Removing Git repo from disk..."
	rm -rf $tmp_puppet
	echo "### Installing some required puppet modules..."
	echo "# puppetlabs-stdlib"
        puppet module install puppetlabs-stdlib > /dev/null 2>&1
	echo "# puppetlabs-ntp"
        puppet module install puppetlabs-ntp > /dev/null 2>&1
fi
echo "### Testing puppet run..."

# Test if puppet would run without errors
puppet apply /etc/puppet/manifests/site.pp --noop --detailed-exitcodes > /dev/null 2>&1

# Rim puppet if test was successfull
if [[ $? != 0 ]];then
	echo "### ERROR: Puppet has problems. Please run 'puppet apply /etc/puppet/manifests/site.pp --noop'! Re-run script after fixing issues."
else
	echo "### Running puppet..."
	puppet apply /etc/puppet/manifests/site.pp
fi

echo "### Finished !"

#!/bin/bash

# Install followings? 1 = yes
install_alias=1
install_vim=1


# DO NOT CHANGE THIS #
tmp_path="/tmp"
tmp_puppet="$tmp_path/PuppetBase"
tmp_vim="$tmp_path/vim"
path_puppet="/etc/puppetlabs"
path_env="$path_puppet/code/environments/production"
path_mod="$path_env/modules"
path_man="$path_env/manifests"
path_vim="/root/.vim"
git_repo="git@github.com:Kuenstlah/Puppet-BaseVM.git"
git_repo_vim="https://github.com/rodjek/vim-puppet.git"

rpm -qa git |grep -q git
if [[ $? != 0 ]];then
	echo "### Installing Git..."
	yum install -y git > /dev/null 2>&1
else
	echo "### Git is already installed, skipping installation"
fi

if [[ $install_vim == 1 ]];then
	echo "### Installing vim..."
	rpm -qa vim-enhanced |grep -q vim
	if [[ $? != 0 ]];then
		yum install -y vim-enhanced > /dev/null 2>&1
	fi
	if [[ ! -d "$path_vim" ]];then
		# vim did not exist until now
	        if [[ -d $tmp_vim ]];then
	                rm -rf $tmp_vim
	        fi

		mkdir -p $path_vim/
                git clone $git_repo_vim $tmp_vim > /dev/null 2>&1
                mv $tmp_vim/* $path_vim/ > /dev/null 2>&1
                rm -rf $tmp_vim
	else
		echo "# vim has already plugins installed. Delete/move '$path_vim' if you want to setup."
	fi
fi

grep -q vim ~/.bashrc
if [[ $? != 0 ]] && [[ $install_alias == 1 ]];then
        echo 'alias vi="vim -p"' >> ~/.bashrc
fi
grep -q puppet_run ~/.bashrc
if [[ $? != 0 ]] && [[ $install_alias == 1 ]];then
        echo "alias puppet_run='puppet apply --hiera_config $path_env/hiera.yaml $path_man/site.pp'" >> ~/.bashrc
fi
grep -q puppet_lookup ~/.bashrc
if [[ $? != 0 ]] && [[ $install_alias == 1 ]];then
        echo "alias puppet_lookup='puppet lookup --explain --environmentpath environments'" >> ~/.bashrc
fi


rpm -qa puppetserver |grep -q puppet
# 0 = rpm is already installed
if [[ $? != 0 ]];then
	rhel=`cat /etc/redhat-release | awk -F ' ' {'print $3'}| head -c 1`
	echo "### Installing puppet..."
	#rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm > /dev/null 2>&1
	rpm -Uvh --force https://yum.puppetlabs.com/puppetlabs-release-pc1-el-${rhel}.noarch.rpm > /dev/null 2>&1
	yum install -y puppetserver> /dev/null 2>&1
else
        echo "### Puppet is already installed, skipping installation"
fi

# Clone git repository and install required modules
echo "### Cloning Git repo into $path_env"
if [[ -d $tmp_puppet ]];then 
	rm -rf $tmp_puppet
fi

if [[ -d "$path_env/.git" ]];then
	echo "# Repository already installed."
else
	git clone $git_repo $tmp_puppet > /dev/null 2>&1
	if [[ $? != 0 ]];then
		echo "### ERROR: Can't clone git repository";exit
	else
		# Check if targeted directory exists, move away if so
		if [[ -d "$path_env" ]];then
			echo "### Moving old environment <$path_env> to <$path_env.bak>"
			mv $path_env $path_env.bak
			if [[ $? != 0 ]];then
				echo "### ERROR: Please move/delete <$path_env.bak> manually."
				exit
			fi
		fi
		mv $tmp_puppet/ $path_env
		echo "### Installing some required puppet modules..."
		echo "# puppetlabs-stdlib"
		/opt/puppetlabs/bin/puppet module install puppetlabs-stdlib > /dev/null 2>&1
		echo "# puppetlabs-ntp"
		/opt/puppetlabs/bin/puppet module install puppetlabs-ntp > /dev/null 2>&1
		rm -rf $tmp_puppet
	fi
fi

echo "### Testing puppet run..."

# Test if puppet would run without errors
/opt/puppetlabs/bin/puppet apply $path_man/site.pp --noop --detailed-exitcodes > /dev/null 2>&1

# Rim puppet if test was successfull
if [[ $? != 0 ]];then
	echo "### ERROR: Puppet has problems. Please run 'puppet apply $path_man/site.pp --noop'! Re-run script after fixing issues."
else
	echo "### Running puppet..."
	puppet apply $path_man/site.pp
fi

echo "### Finished !"

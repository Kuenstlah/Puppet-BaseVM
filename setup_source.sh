#!/bin/bash

####################################################################################
# DO NOT CHANGE SOMETHING BELOW THIS LINE, IF YOU DO NOT KNOW WHAT YOU ARE DOING ! #
####################################################################################
tmp_path="/tmp"
tmp_puppet="$tmp_path/PuppetBase"
tmp_vim="$tmp_path/vim"
path_puppet="/etc/puppetlabs"
path_env="$path_puppet/code/environments/production"
path_mod="$path_env/modules"
path_man="$path_env/manifests"
path_vim="/root/.vim"
rit_repo="git@github.com:Kuenstlah/Puppet-BaseVM.git"
git_repo_vim="https://github.com/rodjek/vim-puppet.git"
log="/tmp/Puppet-BaseVM.log"

function usage
{
    echo -e "$(dirname "$0") --debug"
	exit
}

while [ "$1" != "" ]; do
    case $1 in
        -tp|--temppath) shift
                                tmp_path="$1"
                                ;;
        --debug )               debug=1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

function usage
{
    echo -e "`pwd`/$0"
}
function logmsg(){
	# logmsg 1 "MSG" : all logmsg with first parameter 1 is debug only
	# $debug = 1 	 : all logmsg will be printed with prefix DEBUG to console
	# $debug = 0 	 : logmsg will print every msg not starting with 1 to logfile
	if [[ "$1" == "1" ]]; then
		if [[ $debug ]]; then
			echo "DEBUG $2"
		fi
	else
		if [[ $debug ]]; then
			echo "DEBUG $1"
		else
			echo "$1" >> $log
		fi
	fi
}

function check_rpm {
	name=$1
	rpm -qa $name |grep -q $name
	if [[ $? != 0 ]];then
		echo "### Installing $name..."
		yum install -y $name > /dev/null 2>&1
		logmsg 1 "New rpm: <$name>"
	else
		logmsg 1 "--- rpm: <$name>"
		echo "### $name is already installed, skipping installation"
	fi

}
function check_module {
        fullname=$1
        name=`echo $fullname | awk -F '-' {'print $2'}`
        if [[ ! -d "$path_mod/$name" ]];then
                logmsg 1 "New module: <$fullname> / <$name> ; Does not exit: <"$path_mod/$name">"
                echo "### Installing $fullname.."
                /opt/puppetlabs/bin/puppet module install $fullname > /dev/null 2>&1
        else
                logmsg 1 "--- module: <$fullname> / <$name>"
        fi
}
function check_selinux {
	status=$1
	grep -i SELINUX= /etc/selinux/config |grep -q $status
	if [[ $? != 0 ]];then
		echo "### Changing SELINUX to status <$status>. Please reboot your system!"
		sed "s/SELINUX=.*/SELINUX=$status/g" -i /etc/selinux/config
	fi
}
function check_puppetrepo {
	rhel=`cat /etc/redhat-release | awk -F ' ' {'print $3'}| head -c 1`
	rpm -Uvh --force https://yum.puppetlabs.com/puppetlabs-release-pc1-el-${rhel}.noarch.rpm > /dev/null 2>&1
}
function delete_folder_tmp_puppet {
	if [[ -d $tmp_puppet ]];then
		rm -rf $tmp_puppet
	fi
}
function install_vim {
	if [[ $install_vim == 1 ]];then
		check_rpm vim-enhanced
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
}
function git_clone_repo {
	if [[ -d "$path_env/.git" ]];then
		echo "### Git repository is already installed"
	else
		echo "### Cloning Git repository..."
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
			delete_folder_tmp_puppet
		fi
	fi
}
function finish {
	echo -e "\n\n### Done. You can start Puppet by using following command: 'puppet apply $path_man/site.pp'"
}

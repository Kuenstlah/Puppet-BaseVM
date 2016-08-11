#!/bin/bash

# Debug messages? Run script with --debug

# Install? 1 = yes
install_alias=1
install_vim=1

####################################################################################
# DO NOT CHANGE SOMETHING BELOW THIS LINE, IF YOU DO NOT KNOW WHAT YOU ARE DOING ! #
####################################################################################

source $(dirname "$0")/setup_source.sh

check_selinux disabled

check_rpm git

install_vim

check_puppetrepo

check_rpm puppetserver

delete_folder_tmp_puppet

git_clone_repo

check_module puppetlabs-stdlib
check_module puppetlabs-ntp

finish

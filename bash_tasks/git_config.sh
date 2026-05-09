#!/bin/bash
git_config_url="https://github.com/ecewrqe/vimrc_version.git"
# git config soon

git_config_list_arr=(
	"user.name,euewrqe"
	"user.email,euewrqe@gmail.com"
)

for config_list in ${git_config_list_arr[@]}; do
	
	IFS="," read -r -a arr <<< ${config_list}
	config_name=${arr[0]}
	config_value=${arr[1]}
	res=`git config --global --list|grep ${config_name}`
	echo ${res}
	if [ -z ${res} ]; then
		git config --global ${config_name} ${config_value}
	fi
done


#git clone ${git_config_url}

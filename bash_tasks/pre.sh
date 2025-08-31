#!/bin/bash
# visudo: euewrqe ALL=(ALL:ALL) NOPASSWD: ALL

PASSWORD=412569JX
CONNECT_IP=10.211.56.1

cd ~/Project

echo "==== pre install ===="
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install git net-tools iputils-ping neovim sshpass -y

if test ! -f ~/.ssh/id_rsa.pub ; then
    echo "==== set ssh_keygen ====="
    ssh-keygen -b 4096 -t rsa -a 100
    cd ~/.ssh
    cat id_rsa.pub > authorized_keys
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/*
fi

echo "==== send id_rsd to host euewrqe@${CONNECT_IP} ===="
# echo "scp ~/.ssh/id_rsa euewrqe@${CONNECT_IP}:~/ubuntu"
# sshpass -p ${PASSWORD} scp ~/.ssh/id_rsa euewrqe@${CONNECT_IP}:~/ubuntu

# git config soon

echo "==== github initialize ===="
git config --global user.name euewrqe
git config --global user.email euewrqe@gmail.com


echo "copy id_rsa.pub to github ssh keys setting"

if test ! -e ~/Project/vimrc_version; then
    echo "==== config vimrc ===="
    git_config_url="git@github.com:ecewrqe/vimrc_version.git"
    git clone ${git_config_url}
fi

[ ! -e "~/.config/nvim" ] && mkdir -p ~/.config/nvim

mkdir -p ~/.config/nvim
PATH_PRE="~/Project"
cp -rf vimrc_version/nvim/* ~/.config/nvim
cp -f ${PATH_PRE}/vimrc_version/_vimrc ~/.vimrc



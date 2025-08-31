#!/bin/bash

vimrc_gitpath=~/Project/vimrc_version

if [ -e ${vimrc_gitpath} ]; then
    # nvim
    echo "==== copy nvim ===="
    if [ -e ~/.config/nvim/init.vim ]; then
        cp ~/.config/nvim/init.vim ${vimrc_gitpath}/nvim/init.vim
        cp -r ~/.config/nvim/blueprint ${vimrc_gitpath}/nvim
    fi

    echo "==== copy vim ===="
    if [ -e ~/.vimrc ]; then
        cp ~/.vimrc ${vimrc_gitpath}/_vimrc
    fi
else
    echo "no such path ${vimrc_gitpath} on the machine "
fi

ls ${vimrc_gitpath}/nvim

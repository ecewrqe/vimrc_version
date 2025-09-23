#!/bin/zsh
cp -f ~/Library/Application\ Support/Code/User/settings.json ~/Projects/vimrc_version/vscode.json
cp -f ~/Library/Application\ Support/Code/User/keybindings.json ~/Projects/vimrc_version/vs_shortcut_keys_win_en.json

if [ -f ~/.config/nvim/init.vim ]; then
    cp -f ~/.config/nvim/init.vim ~/Projects/vimrc_version/init.vim
fi

if [ -d ~/.config/nvim/blueprint ]; then
    rm -fr ~/Projects/vimrc_version/nvim/blueprint
    cp -fr ~/.config/nvim/blueprint ~/Projects/vimrc_version/nvim/
fi

if [ -f ~/.vimrc ]; then
    cp -f ~/.vimrc ~/Projects/vimrc_version/.vimrc
fi

if [ -f ~/.tmux.conf ]; then
    cp -f ~/.tmux.conf ~/Projects/vimrc_version/tmux.conf
fi

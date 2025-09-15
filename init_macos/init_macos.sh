#!/bin/bash

# git clone https://github.com/ecewrqe/vimrc_version
# cd vimrc_version || exit 1

# Copy when selected and paste with right mouse button on iterm2
# General > Selection > "Copy to pasteboard on selection"
# Pointer > Paste from Clipboard > Right button single click

# alt key as meta key
# Profiles > Keys > Left/Right option key: Esc+

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

PROFILE="$HOME/.zprofile"
if ! grep -q 'brew shellenv' "$PROFILE"; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$PROFILE"
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew installation failed. Please check the installation script output for errors."
    exit 1
fi

brew update

# ApplePressAndHoldEnabled, KeyRepeat, InitialKeyRepeat any setting not found
# will add each settings then exit the script.
# if found, continue to next step.

settings=("ApplePressAndHoldEnabled" "KeyRepeat" "InitialKeyRepeat")

for setting in "${settings[@]}"; do
    if ! defaults read -g "$settings" 2>/dev/null; then
        echo "Setting $setting not found. Adding default settings and exiting."
        defaults write -g ApplePressAndHoldEnabled -bool false
        defaults write -g KeyRepeat -int 2
        defaults write -g InitialKeyRepeat -int 15
        echo "Default settings added. Please restart PC."
        exit 0
    fi
done

# Install VS Code and extensions
brew install --cask visual-studio-code

# Copy settings
cp -f ~/Projects/vimrc_version/vscode.json ~/Library/Application\ Support/Code/User/settings.json
cp -f ~/Projects/vimrc_version/vs_shortcut_keys_win_en.json ~/Library/Application\ Support/Code/User/keybindings.json

if command -v code >/dev/null 2>&1; then
    sh ./vscode_extension_install_list.sh
else
    echo "VS Code 'code' command not found. Please run 'Shell Command: Install code command in PATH' from VS Code."
fi

# Node.js installation via nvm
./node_install.sh

npm install -g @anthropic-ai/claude-code
npm install -g @google/gemini-cli

# oh-my-zsh installation
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-completions
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# give me sshkey command no passphrase prompt
ssh-keygen -t rsa -b 4096 -C "euewrqe@gmail.com" -f ~/.ssh/id_rsa -N ""

cat ~/.ssh/id_rsa >> ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub

# prompt
read -r -p "Copy the above public key to GitHub/GitLab/Bitbucket and press Enter to continue..."

brew install gh -y

gh auth login

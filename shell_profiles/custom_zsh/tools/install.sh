#!/bin/sh
#
# This script should be run via curl:

set -e

# expands id -u -n to the USER variable
# ${variable:start:length}
USER=${USER:-$(id -u -n)}
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
HOME="${HOME:-$(eval echo ~$USER)}"

custom_zsh=${ZSH:+yes}

zdot="${ZDOTDIR:-$HOME}"

if [ -n "$ZDOTDIR" ] && [ "$ZDOTDIR" != "$HOME" ]; then
  ZSH="${ZSH:-$ZDOTDIR/ohmyzsh}"
fi
ZSH="${ZSH:-$HOME/.oh-my-zsh}"

REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO.git}}
BRANCH=${BRANCH:-master}


CHSH=${CHSH:-yes}
RUNZSH=${RUNZSH:-yes}
KEEP_ZSHRC=${KEEP_ZSHRC:-no}

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

user_can_sudo() {
  # Check if sudo is installed
  command_exists sudo || return 1
  case "$PREFIX" in
  *com.termux*) return 1 ;;
  esac

  ! LANG= sudo -n -v 2>&1 | grep -q "may not run sudo"
}

if [ -t 1 ]; then

else
fi
# %Y year, $m month, %d day
echo $(date +'%Y-%m-%d %H:%M:%S') 
# zshroadmap, zshmisc, zshexpn, zshparam, zshoptions, zshbuiltins, zshzle, zshcompwid, zshcompsys, zshmodules, zshmisc, zshcontrib
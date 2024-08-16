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
  is_tty() {
    true
  }
else
  is_tty() {
    false
  }
fi

supports_hyperlinks() {
  # -n is not null, -z is null
  if [ -n "$FORCE_HYPERLINK" ]; then
    [ "$FORCE_HYPERLINK" != 0 ] # 0 is true, 1 is false
    return $?
  fi

  # If stdout is not a tty
  is_tty || return 1

  # DomTerm terminal emulator 
  if [ -n "$DOMTERM" ]; then
    return 0
  fi

  # VTE-based terminals
  if [ -n "$VTE_VERSION" ]; then
    [ $VTE_VERSION -ge 5000 ]
    return $?
  fi

  case "$TERM_PROGRAM" in
  Hypter|iTerm.app|terminology|WezTerm|vscode) return 0 ;;
  esac

  case "$TERM" in 
  xterm-kitty|alacritty|alacritty-direct) return 0 ;;
  esac

  # xfce4-terminal
  if [ "$COLORTERM" = "xfce4-terminal" ]; then
    return 0
  fi

  if [ -n "$WT_SESSION" ]; then
    return 0
  fi
  
  return 1
}

supports_truecolor() {
  case "$COLORTERM" in
  truecolor|24bit) return 0 ;;
  esac

  case"$TERM" in 
  iterm|\
  tmux-truecolor|\
  linux-truecolor|\
  xterm-truecolor|\
  screen-truecolor) return 0 ;;
  esac

  return 1
}

fmt_link() {
  if supports_hyperlinks; then
    printf '\033]8;;%s\033\\%s\033]8;;\033\\\n' "$1" "$2"
    return
  fi

  case "$3" in
  --text) printf '%s\n' "$2" ;;
  --url|*) fmt_underline "$2" ;;
  esac
}

fmt_underline() {
  is_tty && printf '\033[4m%s\033[24m\n' "$*" || printf '%s\n' "$*"
}

fmt_code() {
  is_tty && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%s`\n' "$*"
}

fmt_error() {
  printf '%sError: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "$FMT_RESET" >&2
}

setup_color() {
  if ! is_tty; then
    FMT_RAINBOW=""
    FMT_RED=""
    FMT_GREEN=""
    FMT_YELLOW=""
    FMT_BLUE=""
    FMT_BOLD=""
    FMT_RESET=""
    return
  fi

  if supports_truecolor; then
    FMT_RAINBOW="
      $(printf '\033[38;2;255;0;0m')
      $(printf '\033[38;2;255;97;0m')
      $(printf '\033[38;2;247;255;0m')
      $(printf '\033[38;2;0;255;30m')
      $(printf '\033[38;2;77;0;255m')
      $(printf '\033[38;2;168;0;255m')
      $(printf '\033[38;2;245;0;172m')
    "
  else
    FMT_RAINBOW="
      $(printf '\033[38;5;196m')
      $(printf '\033[38;5;202m')
      $(printf '\033[38;5;226m')
      $(printf '\033[38;5;082m')
      $(printf '\033[38;5;021m')
      $(printf '\033[38;5;093m')
      $(printf '\033[38;5;163m')
    "
  fi

  FMT_RED=$(printf '\033[31m')
  FMT_GREEN=$(printf '\033[32m')
  FMT_YELLOW=$(printf '\033[33m')
  FMT_BLUE=$(printf '\033[34m')
  FMT_BOLD=$(printf '\033[1m')
  FMT_RESET=$(printf '\033[0m')
}

setup_ohmyzsh() {
  umask g-w,o-w
  echo "${FMT_BLUE}Cloning Oh My Zsh...${FMT_RESET}"
  command_exists git || {
    fmt_error "git is not installed"
    exit 1
  }

  ostype=$(uname)
  if [ -z "${ostype%CYGWIN*}" ] && git --version | grep -Eq "msysgit|windows"; then
    fmt_error "Windows/MSYS Git is not supported on Gygwin"
    fmt_error "Make sure the Cygwin git package is installed and is first on the \$PATH"
    exit 1
  fi

  git init --quiet "$ZSH" && cd "$ZSH" \
  && git config core.eol lf \
  && git config core.autocrlf false \
  && git config fsck.zeroPaddedFilemode ignore \
  && git config fetch.fsck.zeroPaddedFilemode ignore \
  && git config receive.fsck.zeroPaddedFilemode ignore \
  && git config oh-my-zsh.remote origin \
  && git config oh-my-zsh.branch "$BRANCH" \
  && git remote add origin "$REMOTE" \
  && git fetch --depth=1 origin \
  && git checkout -b "$BRANCH"
}
# %Y year, $m month, %d day
echo $(date +'%Y-%m-%d %H:%M:%S') 
# zshroadmap, zshmisc, zshexpn, zshparam, zshoptions, zshbuiltins, zshzle, zshcompwid, zshcompsys, zshmodules, zshmisc, zshcontrib
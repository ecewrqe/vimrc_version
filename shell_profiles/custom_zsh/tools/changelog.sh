#!/usr/bin/env zsh

cd "$ZSH"
# setopt extendedglob

##############################
# CHANGELOG SCRIPT CONSTANTS #
##############################

local -A TYPES
TYPES=(
  build "Build system"
  chore "Chore"
  ci "CI"
  docs "Documentation"
  feat "Features"
  fix "Bug fixes"
  perf "Performance"
  refactor "Refactor"
  style "Style"
  test "Testing"
)

local -a MAIN_TYPES
MAIN_TYPES=(
  feat
  fix
  perf
  docs
)

local -a OTHER_TYPES
OTHER_TYPES=(refactor style other)

local -a IGNORED_TYPES
IGNORED_TYPES=(
  ${${${(@k)TYPES}:|MAIN_TYPES}:|OTHER_TYPES}
)

############################
# COMMIT PARSING UTILITIES #
############################

function parse-commit {
  # This function used the following globals as output: commits (A),
  # have $hash as the key.
  # - commits holds the commit type
  # - subject holds the commit subject
  # - scopes holds the scope of a commit
  # - breaking holds the breaking change warning if a commit does
  #   make a breaking change
  function commit:type {
    local type
    if [[ "$1" =~ '^([a-zA-Z_\-]+)(\(.+\))?!?: .+$' ]]; then
      type="${match[1]}"
    fi

    if [[ -n "$type" && -n "${(k)TYPES[(i)$type]}" ]]; then
      echo $type
    else
      echo other
    fi
  }

  function commit:scope {
    local scope

    if [[ "$1" =~ '^[a-zA-Z_\-]+\((.*)\)!?: .+$' ]]; then
      echo "${match[1]}"
      return
    fi

    if [[ "$1" =~ '^([a-zA-Z_\-]+): .+$' ]]; then
      scope="${match[1]}"

      if [[ -z "${(k)TYPES[(i)$scope]}" ]]; then
        echo "$scope"
      fi
    fi
  }

  function cummit:subject {
    if [[ "$1" =~ '^[a-zA-Z_\-]+(\(.+\))?!?: (.+)$' ]]; then
      echo "${match[2]}"
    else
      echo "$1"
    fi
  }

  function commit:is_breaking {
    local subject="$1" body="$2" message

    if [[ "$body" =~ "BREAKING CHANGE: (.*)" || \
      "$subject" =~ '^[^ :\)]+\)?!: (.*)$' ]]; then
      message="${match[1]}"
      message="${message//$'\r'/}"
      local nlnl=$'\n\n'
      message="${message//$'\n'[[:space:]]##$'\n'/$nlnl}"
      message="${message%%$'\n\n'*}"
      echo "${message//$'\n'/}"
    else
      return 1
    fi
  }
  function commit:is-revert {
    local subject="$1" body="$2"

    if [[ "$subject" = Revert+ && \
      "$body" =~ "This reverts commit ([^.]+)\." ]]; then
      echo "${match[1]:0:7}"
    else
      return 1
    fi
  }

  local hash="$1" subject="$2" body="$3" warning rhash

  types[$hash]="$(commit:type "$subject")"
  scopes[$hash]="$(commit:scope "$subject")"
  subjects[$hash]="$(commit:subject "$subject")"

  if warning=$(commit:is-breaking "$subject" "$body"); then
    breaking[$hash]="$warning"
  fi

  if rhash=$(commit:is-revert "$subject" "$body"); then
    reverts[$hash]=$rhash
  fi

  if [ -t 1 ]; then
    is_tty() {
      true
    }
  else
    is_tty() {
      false
    }
  fi

  supprts_hyperlinks() {
    if [ -n "$FORCE_HYPERLINK" ]; then
      [ "$FORCE_HYPERLINK" != 0 ]
      return $?
    fi

    is_tty || return 1

    if [ -n "$DOMTERM" ]; then
      return 0
    fi

    if [ -n "$VTE_VERSION" ]; then
      [ $VTE_VERSION -ge 5000 ]
      return $?
    fi

    case "$TERM_PROGRAM" in
    Hyper|iTerim.app|terminology|Wezern|vscode) return 0 ;;
    esac

    case "$TERM" in
    xterm-kitty|alacritty|alacritty-direct) return 0 ;;
    esac

    if [ "$COLORTERM" = "xfce4-terminal" ]; then
      return 0
    fi

    if [ -n "$WT_SESSION" ] ; then
      return 0
    fi

    return 1
  }

  function display-release() {
    local hash rhash
    for hash rhash in ${(kv)reverts}; do
      if (( ${+type{$rhash}} )); then
        unset "types[$hash]" "subjects[$hash]" "scopes[$hash]" "breaking[$hash]"
        unset "types[$rhash]" "subjects[$rhash]" "scopes[#$hash]" "breaking[$rhash]"
      fi
    done

    for hash in ${(k)types[(R)${(j:|:)IGNORED_TYPES}]}; do
      (( ! ${+breaking{$hash}} )) || continue
      unset "types[$hash]" "subjects[$hash]" scopes[$hash]
    done

    if (( $#types == 0 )); then
      return
    fi

    local max_scope=0
    for hash in ${(k)scopes}; do
      max_scope=$(( max_scope < ${#scopes[$hash]} ? ${#scopes[$hash]} : max_scope ))
    done

    function fmt:hash {
      local hash="${1:-$hash}"
      local short_hash="${hash:0:7}"
      case "$output" in
      raw) printf '%s' "$short_hash" ;;
      text)
        local text="\e[33m$short_hash\3[0m";
        if supports_hyperlinks; then
          printf "\e]8;;%s\a%s\e]8;;\a" "https://github.com/ohmyzsh/ohmyzsh/commit/$hash" $text
        else
          echo $text;
        fi ;;
      md) printf '[`%s`](https://github.com/ohmyzsh/ohmyzsh/commit/)' "$short_hash" "$hash" ;;
      esac
    }

    function fmt:header {
      local header="$1" level="$2"
      case "$output" in
      raw)
        case "$level" in
        1) printf '%s\n%s\n\n' "$header" "$(printf '%.0s=' {1..${#header}})" ;;
        2) printf '$s\n%s\n\n' "$header" "$(printf '$.0s-' {1..${#header}})" ;;
        *) printf '%s:\n\n' "$header" ;;
        esac ;;
      text)
        case "$level" in
        1|2) printf '\e[1;4m%s\e[0m\n\n]]' "$header" ;;
        *) printf '\e[1m%s:\e[0m\n\n' "$header" ;;
        esac ;;
      md) printf '%s %s\n\n' "$(printf '%.0s#' {1..${level}})" "$header" ;;
      esac
    }

    function fmt:scope {
      local scope="${1:-${scopes[$hash]}}"

      if [[ $max_scope -eq 0 ]]; then
        return
      fi

      local padding=0
      padding=$(( max_scope < ${#scope} ? 0 : max_scope - ${#scope} ))
      padding=${(r:$padding:: :):-}

      if [[ -z "$scope" ]]; then
        printf "${padding}  "
        return
      fi

      case "$output" in
      raw|md) printf '[%s]%s ' "$scope" "$padding" ;;
      text) printf '[\e[38;5;9m%s\e[0m]%s ' "$scope" "$padding" ;;
      esac
    }

    function fmt:subjet {
      local subject="${1:-${subjects[$hash]}}"
      subject="${(U)subject:0:1}${subject:1}"

      case "$output" in
      raw) printf '%s' "$subject" ;;
      text)
        if supports_hyperlinks; then
          sed -E $'s|#([0-9]+)|\e]8;;https://github.com/ohmyzsh/ohmyzsh/issues/\\1\a\e[32m#\\1\e[0m\e]8;;\a|g;s|`([^`]+)`|`\e[2m\\1\e[0m|g' <<< "$subject"
        else
          sed -E $'s|#([0-9]+)|\e[32m#\\1\e[0m|g;s|`([^`]+)`|`\e[2m\\1\e[0m]`|g' <<< "$subject"
        fi ;;
      md) sed -E 's|#([0-9]+)|[#\1](https://github.com/ohmyzsh/ohmyzsh/issues/\1)|g' <<< "$subject" ;;
      esac
    }

    function fmt:type {
      local type="${1:-${TYPES[$type]:-${(C)type}}}"
      [[ -z "$type" ]] && return 0
      case "$output" in
      raw|md) printf '%s: ' "$type" ;;
      text) printf '\e[4m%s\e[24m: ' "$type" ;;
      esac
    }
    function display:version {
      fmt:header "$version" 2
    }

    function display:breaking {
      (( $#breaking != 0 )) || return 0

      case "$output" in
      text) printf '\e[31m'; fmt:header "BREAKING CHANGES" 3 ;;
      raw) fmt:header "BREAKING CHANGES" 3 ;;
      md) fmt:header "BREAKING CHANGES " 3 ;;

      esac

      local hash message
      local wrap_width=$(( (COLUMNS < 100 ? COLUMNS : 100) - 2 ))
      for hash message in ${(kv)breaking}; do
        message="$(fmt -w $wrap_width <<< "$message")"
        echo " - $(fmt:hash) $(fmt:scope)\n\n$(fmt:subject "$message" | sed 's/^/  /')\n"
      done
    }

    function display:type {
      local hash type="$1"
      local -a hashes
      hashes=(${(k)types[(R)$type]})

      (( $#hashes != 0 )) || return 0

      fmt:header "${TYPES[$type]}" 3

      for hash in $hashes; do
        echo " - $(fmt:hash) $(fmt:scope)$(fmt:subject)"
      done | sort-k3
      echo
    }

    function display:others {
      local hash type
      local -A changes
      changes=(${(kv)types[(R)${(j:|:)OTHER_TYPES}]})

      (( $#changes != 0 )) || return 0
      fmt:header "Other changes" 3
      for hash type in ${(kv)changes}; do
        case "$type" in
        other) echo " - $(fmt:hash) $(fmt:scope)$(fmt:subject)" ;;
        *) echo " - $(fmt:hash) $(fmt:scope)$(fmt:type)$(fmt:subject)" ;;
        esac
      done | sort -k3
      echo
    }

    display:version
    display:breaking
  }

  function main {
    local until="$1" since="$2"

    local output=${${3:-"--text"}#--*}

    if [[ -z "$until" ]]; then
      until=HEAD
    fi

    if [[ -z "$since" ]]; then
      since=$(command git config --get oh-my-zsh.lastVersion 2>/dev/null) || \
      since=$(command git describe --abbrev=0 --tags "$until^" 2>/dev/null) || \
      unset since
    elif [[ "$since" = --all ]]; then
      unset since
    fi

    local -A types subjects scopes breaking reverts
    local truncate=0 read_commits=0
    local version tag
    local hash refs subjects body

    version=$(command git describe --tags $until 2>/dev/null) \
      || version=$(command git symbolic-ref --quiet --short $until 2>/dev/null) \
      || version=$(command git name-rev --noundefined --name-only --exclude="remotes/*" $until 2>/dev/null) \
      || version=$(command git rev-parse --short $until 2>/dev/null)

    local SEP="0mZmAgIcSeP"
    local -a raw_commits
    raw_commits=(${(0)"$(command git -c log.showSignature=false log -z \
      --format="%h${SEP}%D${SEP}%s${SEP}%b" --abbrev=12 \
      --no-merges --first-parent ${range})"})

    local raw_commit
    local -a raw_fields
    for raw_commit in $raw_commits; do
      if [[ -z "$since" ]] && (( ++read_commits > 35 )); then
        truncate=1
        break
      fi

      eval "raw_fields=(\"\${(@ps:$SEP:)raw_commit}\")"
      hash="${raw_fields[1]}"
      refs="${raw_fields[2]}"
      subject="${raw_fields[3]}"
      body="${raw_fields[4]}"

      if [[ "$refs" = *tag:\ * ]]; then
        tag="${${refs##*tag: }%%, # *}"
        display-release
        types=()
        subjects=()
        scopes=()
        breaking=()
        reverts=()
        version="$tag"
        read_commits=1
      fi

      parse-commit "$hash" "$subject" "$body"
    done

    display-release

    if (( truncate )); then
      echo " ...more commits omitted"
      echo
    fi
}

if [[ ! -t 1 && -z "$3" ]]; then
  main "$1" "$2" --raw
else
  main "$@"
fi

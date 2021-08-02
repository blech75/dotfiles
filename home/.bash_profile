# shellcheck shell=bash

# https://github.com/andsens/homeshick/wiki/Installation
#
# export HOMESHICK_DIR="${HOME}/.homesick/repos/homeshick"
export HOMESHICK_DIR=/usr/local/opt/homeshick
# shellcheck disable=SC1091
source "${HOMESHICK_DIR}/homeshick.sh"

# enable homeshick autocompletion
#source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
# shellcheck disable=SC1091
source "${HOMESHICK_DIR}/etc/bash_completion.d/homeshick-completion.bash"

# grab homebrew prefix if it's installed
if [ "$(command -v brew)" != '' ]; then
  brew_prefix="$(brew --prefix)"
else
  brew_prefix=""
fi

# bash completion setup (homebrew)
if [ -f "${brew_prefix}/etc/bash_completion" ]; then
  # shellcheck disable=SC1091
  source "${brew_prefix}/etc/bash_completion"
fi

# keep track of installed homebrew formulae
if [ "$(command -v brew)" != '' ]; then
  function installed-brews() {
    brew list --versions >~/.homebrew-installed
  }

  installed-brews
fi

# outputs name and status of vagrant machine if passed path is child of a
# vagrant project
function vagrant_local_status() {
  # https://github.com/monochromegane/vagrant-global-status
  local VGS="vagrant-global-status"

  # note: a fully resolved path (no symlinks) is required because the path that
  # vagrant-global-status outputs also resolves symlinks.
  local TARGET_PATH=""

  # this function accepts a single (optional) argument, the path to check
  # against vagrant-global-status.
  if [ $# -lt 1 ]; then
    # resolve symlinks of current dir
    TARGET_PATH="$(pwd -P)"

  # check to see if the passed dir exists
  elif [[ $# -eq 1 && -d $1 ]]; then
    # resolve symlinks of passed dir
    TARGET_PATH="$(cd "$1" && pwd -P)"
  else
    return 1
  fi

  # return immediately if we can't find the tool in $PATH
  if [ "$(command -v $VGS)" = "" ]; then
    return 1
  fi

  # capture output of vagrant-global-status. we'll need to process it a few
  # more times later.
  local VAGRANT_STATUS
  VAGRANT_STATUS="$($VGS)"

  # extract dir paths (5th col)
  local ALL_VM_PATHS
  ALL_VM_PATHS=$(echo "$VAGRANT_STATUS" | awk '{ print $5 }')

  # holds the path to the VM (a parent of TARGET_PATH)
  local MATCHED_VM_PATH=""

  # attempt to match one one of the paths with TARGET_PATH
  for p in $ALL_VM_PATHS; do
    # test if TARGET_PATH is a child dir of a candidate path by attempting to
    # remove candidate path from begnning of TARGET_PATH, (re-)combining with
    # candiate path, and checking to see if it's identical to TARGET_PATH.
    if [ "${p}${TARGET_PATH##$p}" = "$TARGET_PATH" ]; then
      MATCHED_VM_PATH=$p
      break
    fi
  done

  # bail if we didn't match anything
  if [ "$MATCHED_VM_PATH" = "" ]; then
    # this is still considered a success
    return 0
  fi

  # holds entire status line(s). we'll process it later
  local MATCHED_VM
  MATCHED_VM=$(echo "$VAGRANT_STATUS" | grep "$MATCHED_VM_PATH")

  # count the number of VMs we've matched, stripping out leading spaces from
  # wc output
  local NUM_VMS
  NUM_VMS=$(echo "$MATCHED_VM" | wc -l | sed -e 's/ //g')

  # FIXME: no multi-machine vagrant right now.
  # https://docs.vagrantup.com/v2/multi-machine/
  if [ "${NUM_VMS}" = "1" ]; then
    # for the line that matches, get extract the desired status info
    local VM_NAME
    VM_NAME="$(echo "$MATCHED_VM" | awk '{ print $2}')"
    local VM_STATUS
    VM_STATUS="$(echo "$MATCHED_VM" | awk '{ print $4}')"

    # FIXME: make output more succinct. need to account for all status values
    # (poweroff|running|saved|...)
    echo "${VM_NAME}:${VM_STATUS}"
  fi

  return 0
}

# enable custom git prompt
if [ -f "${brew_prefix}/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  export GIT_PROMPT_THEME=Custom
  export __GIT_PROMPT_DIR=${brew_prefix}/opt/bash-git-prompt/share
  # shellcheck disable=SC1091
  source "${brew_prefix}/opt/bash-git-prompt/share/gitprompt.sh"
fi

### set some shell options
# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html

# history config
export HISTCONTROL=erasedups
export HISTSIZE=10000
export HISTTIMEFORMAT="%Y-%m-%d %T "
shopt -s histappend

function hgrep() {
  history | grep "$1"
}

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# allow for globbing
# requires bash 4.x
shopt -s globstar

# path setup
# FIXME: refactor this to something better
home_path="$HOME/bin"
usr_local_path="/usr/local/bin:/usr/local/sbin"
mysql_path="/usr/local/opt/mysql@5.7/bin"
postgres_path="/usr/local/opt/postgresql@9.6/bin"
composer_path="$HOME/.composer/vendor/bin"
php_path="/usr/local/opt/php@7.4/sbin:/usr/local/opt/php@7.4/bin:"
export PATH=$home_path:$usr_local_path:$postgres_path:$mysql_path:$php_path:$composer_path:$PATH

# other path setup stuff
# export MANPATH=/opt/local/man:$MANPATH
# export CVSROOT=/Users/justin/.CVS
#export VIMRUNTIME=/Users/justin/.vim
#export PKG_CONFIG_PATH=/sw/lib/pkgconfig:/usr/X11R6/lib/pkgconfig:/Library/Frameworks/Mono.framework/Versions/Current/lib/pkgconfig
#export DYLD_LIBRARY_PATH=/opt/local/lib:/opt/local/var/macports/software/ImageMagick/6.3.1-4_0+darwin_8/opt/local/lib/:$DYLD_LIBRARY_PATH
export PERL5LIB="${PERL5LIB}:/${HOME}/.pm"
#export JAVA_HOME='/System/Library/Frameworks/JavaVM.framework/Home'
#export JAVA_HTML='/Library/Java/Home'
#export PYTHONSTARTUP=~/.pythonstartup

# http://stackoverflow.com/a/6588410/2284440
# export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"

# character set setup
export LANG='en_US.UTF-8'
#export LC_CTYPE=en_US.UTF-7
#export KCODE=u

# platform targets (forget why i needed this)
# export RC_ARCHS='i386'
RC_ARCHS=$(uname -m)
export RC_ARCHS

# ignore mac os resource forks in zip files
# FIXME: is this necessary/supported anymore? check current behavior
#export ZIPOPT="-df"

# add color to directory lists
alias ls='ls -G'
#export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:'

#man() { man -t "$@" | open -f -a Preview; }

# helper to grep current dir for string
function lsg() {
  # shellcheck disable=SC2010
  ls -la | grep "$1"
}

# create instant/temp local http server
# from https://gist.github.com/1525217 with a few tweaks by me
function localhost() {
  local PORT=8000
  if [ "$1" != "" ]; then
    PORT=$1
  fi
  # counter-intuitive that we want to open the browser before we know the
  # server is successfully launched, but we need to monitor and kill the server
  # when we're done.
  open "http://localhost:${PORT}" && /usr/bin/python -m SimpleHTTPServer "${PORT}"
}

# javascript consoles
alias js="java org.mozilla.javascript.tools.shell.Main"
alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"

# unix shortcuts
alias rm='rm -i'
alias rmds='find . -name \.DS_Store -delete'
alias rmpyc='find . -name "*.pyc" -delete'
#alias flushcache='dscacheutil -flushcache'

# git shortcuts
## TODO: port this to gitconfig
#
#alias gsu='git submodule update --init && git submodule foreach git submodule update --init'
alias gsu='git submodule update --init'
alias gsb='git submodule foreach git branch'
alias gsba='git submodule foreach git branch -a'
alias gssl='git submodule foreach git stash list'
alias gsst='git submodule foreach "git status || :"'

# alias colordiff to diff; colordiff is installed via brew
if [ "$(command -v colordiff)" != '' ]; then
  alias diff='colordiff'
fi

# To link Rubies to Homebrew's OpenSSL 1.1 (which is upgraded)
RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export RUBY_CONFIGURE_OPTS

# rbenv setup
# rbenv is installed via brew
if [ "$(command -v rbenv)" != '' ]; then
  eval "$(rbenv init -)"
fi

export NODE_BUILD_DEFINITIONS="${brew_prefix}/opt/node-build-update-defs/share/node-build"

# nodenv setup
# nodenv is installed via brew
if [ "$(command -v nodenv)" != '' ]; then
  eval "$(nodenv init - --no-rehash)"
fi

# pyenv setup
# pyenv is installed via brew
if [ "$(which pyenv)" != '' ]; then
  # Add pyenv executable to PATH and enable shims
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"

  # Load pyenv into the shell
  eval "$(pyenv init -)"
fi

# enable npm autocomplete
# if [ "$(command -v npm)" != '' ]; then
#   # https://docs.npmjs.com/cli/completion
#   source <(npm completion)
# fi

# helper function to run node cli executable in context of the package
# http://stackoverflow.com/a/32059751/2284440
# function npm-exec() {
#   $(npm bin)/$*
# }

# remind me to keep my dotfiles up to date daily
homeshick --quiet check dotfiles --local-only
if [[ $? -eq 88 ]]; then
  echo
  echo "Rememeber to commit your dotfiles!"
  (homeshick cd dotfiles && git status --short)
fi

# overcommit setup
# https://github.com/brigade/overcommit/
#if [ "$(command -v overcommit)" != '' ]; then
#  GIT_TEMPLATE_DIR=$(overcommit --template-dir)
#  export GIT_TEMPLATE_DIR
#fi

# https://github.com/github/hub#aliasing
# if [ "$(command -v hub)" != '' ]; then
#   eval "$(hub alias -s)"
# fi

# . $(brew --prefix asdf)/asdf.sh

# add go packages to path
# FIXME: check for go dir before appending path
export GOPATH="${HOME}/.go"
export PATH="${GOPATH}/bin:${PATH}:${brew_prefix}/opt/go/libexec/bin"

# for lesspipe
export LESSOPEN="|${brew_prefix}/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=2

# add cabal packages (haskell) to path
# FIXME: check for cabal dir before appending path
export PATH="${HOME}/.cabal/bin:${PATH}"

# ipython is installed via brew
export PATH="${brew_prefix}/opt/ipython@5/bin:$PATH"

google_cloud_sdk="${brew_prefix}/Caskroom/google-cloud-sdk/latest"
# shellcheck disable=SC1091
source "${google_cloud_sdk}/google-cloud-sdk/path.bash.inc"
# shellcheck disable=SC1091
source "${google_cloud_sdk}/google-cloud-sdk/completion.bash.inc"

# https://cloud.google.com/appengine/docs/standard/python/tools/remoteapi#using_the_remote_api_in_a_local_client
export GAE_SDK_ROOT="${google_cloud_sdk}/google-cloud-sdk/platform/google_appengine"
export PYTHONPATH="${GAE_SDK_ROOT}${PYTHONPATH:+":$PYTHONPATH"}"

# export PYTHONDONTWRITEBYTECODE=0

# configure completion for green (python test runner)
# shellcheck disable=SC1090
which green >&/dev/null && source "$(green --completion-file)"

# use green completion for './scripts/test', too.
#
# NOTE: using './scripts/test' as the "completion command name" is a
# workaround to avoid conflicting with bash's built-in 'test' command. since the
# usual method running our test script is via './scripts/test', this works
# "good enough" for now. :-/ (alternatively, make a custom alias for the test
# runner and assign completions to that.)
#
complete -p green >&/dev/null && complete -F _green_completion ./scripts/test

# useful for testing shell interactions in a "clean" environment
#
CLEANPATH="/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin"
# shellcheck disable=SC2139
alias cleanenv="env -i HOME=\"\$HOME\" PATH=\"$CLEANPATH\" TERM=\"\$TERM\" /bin/bash --noprofile --norc"

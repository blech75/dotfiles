# https://github.com/andsens/homeshick/wiki/Installation
source "$HOME/.homesick/repos/homeshick/homeshick.sh"

# enable git prompt
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto verbose name"
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWCOLORHINTS=true

source /opt/local/share/git/contrib/completion/git-prompt.sh

function git_sha() {
  # git log -1 --pretty=format:%h 2> /dev/null
  git rev-parse --short HEAD 2>/dev/null
}



# define colors so they can be more easily used.
# include brackets around colors to allow proper line length calculation
COLOR_GRAY="\[\e[30;40m\]"
COLOR_RED="\[\e[31;40m\]"
COLOR_GREEN="\[\e[32;40m\]"
COLOR_YELLOW="\[\e[33;40m\]"
COLOR_BLUE="\[\e[34;40m\]"
COLOR_MAGENTA="\[\e[35;40m\]"
COLOR_CYAN="\[\e[36;40m\]"

COLOR_GRAY_BOLD="\[\e[30;1m\]"
COLOR_RED_BOLD="\[\e[31;1m\]"
COLOR_GREEN_BOLD="\[\e[32;1m\]"
COLOR_YELLOW_BOLD="\[\e[33;1m\]"
COLOR_BLUE_BOLD="\[\e[34;1m\]"
COLOR_MAGENTA_BOLD="\[\e[35;1m\]"
COLOR_CYAN_BOLD="\[\e[36;1m\]"

COLOR_NONE="\[\e[0m\]"


# add nice colored prompt
function composite_ps1() {
  local TIME="${COLOR_GRAY_BOLD}[${COLOR_BLUE_BOLD}\@${COLOR_GRAY_BOLD}]${COLOR_NONE}"
  local HIST="${COLOR_GRAY_BOLD}[${COLOR_YELLOW_BOLD}\!${COLOR_GRAY_BOLD}]${COLOR_NONE}"
  local USER_HOST="${COLOR_GRAY_BOLD}[${COLOR_GREEN_BOLD}\u@\h${COLOR_GRAY_BOLD}]${COLOR_NONE}"
  local DIR="${COLOR_GRAY_BOLD}[${COLOR_MAGENTA_BOLD}\w${COLOR_GRAY_BOLD}]${COLOR_NONE}"

  local ps1="${TIME}-${HIST}-${USER_HOST}-${DIR}"

  local git_status="$(__git_ps1 '%s')"
  if [ "${git_status}" != "" ]; then
    local GIT="${COLOR_GRAY_BOLD}[${COLOR_RED_BOLD}${git_status} @$(git_sha)${COLOR_GRAY_BOLD}]${COLOR_NONE}"
    ps1="${ps1}-${GIT}"
  fi

  printf %s "$ps1"
}

# http://stackoverflow.com/a/13997892/2284440
function set_bash_prompt() {
  PS1="\n$(composite_ps1)\n\$ "
}

# http://superuser.com/a/623305/327091
PROMPT_COMMAND="set_bash_prompt; $PROMPT_COMMAND"


# currently broken
#source ~/tools/vagrant-bash/inc/vagrant.sh


# history config
export HISTCONTROL=erasedups
export HISTSIZE=10000
export HISTTIMEFORMAT="%Y-%m-%d %T "
shopt -s histappend

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize



# path setup
home_path=$HOME/bin
apache_path=/opt/local/apache2/bin
mysql_path=/opt/local/lib/mysql5/bin
#oracle_path=/opt/instantclient_10_2
vmware_path=/Library/Application\ Support/VMware\ Fusion
macports_path=/opt/local/bin:/opt/local/sbin
local_path=/usr/local/bin:/usr/local/sbin
heroku_path=/usr/local/heroku/bin
export PATH=$home_path:$heroku_path:$vmware_path:$apache_path:$mysql_path:$macports_path:$local_path:$PATH
launchctl setenv PATH "$PATH"

# other path setup stuff
export MANPATH=/opt/local/man:$MANPATH
export CVSROOT=/Users/justin/.CVS
#export VIMRUNTIME=/Users/justin/.vim
#export PKG_CONFIG_PATH=/sw/lib/pkgconfig:/usr/X11R6/lib/pkgconfig:/Library/Frameworks/Mono.framework/Versions/Current/lib/pkgconfig
#export DYLD_LIBRARY_PATH=/opt/local/lib:/opt/local/var/macports/software/ImageMagick/6.3.1-4_0+darwin_8/opt/local/lib/:$DYLD_LIBRARY_PATH
#export DYLD_LIBRARY_PATH=/opt/instantclient_10_2:$DYLD_LIBRARY_PATH
export PERL5LIB=$PERL5LIB:/Users/justin/.pm
#export PYTHONPATH='/Library/Frameworks/Python.framework/Versions/2.4/lib/python2.4/site-packages'
#export PYTHONPATH=/usr/local/lib/python2.6/site-packages/:/opt/local/Library/Frameworks/Python.framework/Versions/Current/lib/python2.6/site-packages/
#export PATH='/Library/Frameworks/Python.framework/Versions/Current/bin:${PATH}'
#export JAVA_HOME='/System/Library/Frameworks/JavaVM.framework/Home'
#export JAVA_HTML='/Library/Java/Home'
export PYTHONSTARTUP=~/.pythonstartup

# character set setup
export LANG='en_US.utf-8'
#export LC_CTYPE=en_US.UTF-7
#export KCODE=u

# platform targets (forget why i needed this)
# export RC_ARCHS='i386'
export RC_ARCHS=`uname -m`

# DP build tools setup
export ANT_ARGS='-find build.xml -l build.log'
export DP_BUILD_TOOLS_HOME=$HOME/tools/dp-build-tools

# ignore mac os resource forks in zip files
#export ZIPOPT="-df"

# add color to directory lists
alias ls='ls -G'
#export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:'


#man() { man -t "$@" | open -f -a Preview; }

function lsg {
    ls -la | grep $1
}

# create instant/temp local http server 
# from https://gist.github.com/1525217
localhost() {
  open "http://localhost:${1}" && python -m SimpleHTTPServer $1
}



# javascript consoles
alias js="java org.mozilla.javascript.tools.shell.Main"
alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"

# apache shortcuts
alias aprs="sudo /opt/local/apache2/bin/apachectl restart"

# unix shortcuts
alias rm='rm -i'
alias rmds='find . -name \.DS_Store -exec rm -rf {} \;'
#alias flushcache='dscacheutil -flushcache'

# rails shortcuts
alias ss='script/server'
alias sc='script/console'
alias rru='rake radiant:extensions:update_all'

# git shortcuts
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias gds='git diff --staged | mate'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -v'
#alias gsu='git submodule update --init && git submodule foreach git submodule update --init'
alias gsu='git submodule update --init'
alias gsb='git submodule foreach git branch'
alias gsba='git submodule foreach git branch -a'
alias gssl='git submodule foreach git stash list'
alias gsst='git submodule foreach "git status || :"'
alias gss='git stash show'
alias gsl='git stash list'


# fixes the weird require issue with veewee/vagrant
# http://www.uncompiled.com/hacky-quick-fix-for-vagrant-veewee-on-mac-os
#export RUBYLIB=$RUBYLIB:/opt/local/lib/ruby/gems/1.8/gems/veewee-0.2.3/lib/:/opt/local/lib/ruby/gems/1.8/gems/virtualbox-0.9.2/lib/

# rbenv setup
if [ `which rbenv` != '' ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# bash completion setup
if [ -f /opt/local/etc/bash_completion ]; then
	. /opt/local/etc/bash_completion
fi

# enable grunt autocomplete
if [ `which grunt` != '' ]; then
  eval "$(grunt --completion=bash)"
fi

# enable homeshick autocompletion
source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"

# remind me to keep my dotfiles up to date
homeshick --quiet refresh

# overcommit setup
# https://github.com/brigade/overcommit/
export GIT_TEMPLATE_DIR=`overcommit --template-dir`


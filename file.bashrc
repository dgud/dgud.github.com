## Bash init file

alias ls='ls -F --color --show-control-chars'
alias pp='pushd'
alias po='popd'

alias gitk="cmd //c /c/opt/Git/cmd/gitk.cmd"

WDIR="$HOME/AppData/Wings3D"
# Start and run wings with esdl
alias wings='werl -run wings_start start -extra $WDIR'

export PAGER=less
export EDITOR=emacs

export MAKEFLAGS=-j5

PATH=/c/opt/emacs-24.2/bin/:$PATH
PATH=/c/opt/SDL-1.2.14/bin/:$PATH
PATH="/c/Program Files/erl5.10/bin":$PATH
PATH="/c/Program Files/NSIS":$PATH
PATH=/c/opt/Git/cmd:$PATH
export PATH

export ESDL_PATH=C:/src/esdl
export ERL_LIBS=C:/src
export WINGS_VCREDIST=/c/Program\ Files/Microsoft\ SDKs/Windows/v7.1/Redist/VC/vcredist_x86.exe

source /c/opt/Git/etc/git-completion.bash
source /c/opt/Git/etc/git-prompt.sh
PS1='--[\u@\h] \[\e[0;34m\]\W/\[\e[0;32m\]$(__git_ps1 " (%s)") $CC_VIEW\[\e[0;34m\]\[\e[0m\]--\n> '
export PS1


## Bash init file

alias ls='ls -F --color --show-control-chars'
alias pp='pushd'
alias po='popd'

alias cds="cd /c/src/"

WDIR="$HOME/AppData/Wings3D"
# Start and run wings with esdl
alias w1='werl +S1 -pa c:/src/wings/ebin -pa c:/src/esdl/ebin -run wings_start start -extra $WDIR'
# Start and run wings with wxWidgets (require a build with 'make wx')
alias w2="werl -pa c:/src/wings/ebin -run wings_start start -extra $WDIR"

export PAGER=less
export EDITOR=emacs

## Let rxvt (backspace) behave as it should
alias rxvt="rxvt -backspacekey ^H -sl 4000 -sr -fn Courier-12 -tn msys -geometry 90x50 -e /bin/bash"

PATH=/c/tools/emacs-23.1/bin/:$PATH
PATH="/c/Program Files (x86)/erl5.7/bin":$PATH
export PATH=/c/tools/SDL-1.2.14/bin:$PATH

export ESDL_PATH=/c/src/esdl

source /git/contrib/completion/git-completion.bash
export PS1='\[\033[32m\]\u@\w\[\033[33m$(__git_ps1 " (%s)"):\n\[\033[0m\]$ '


export CLICOLOR=1
export LSCOLORS=ExGxFxdxCxDxDxxbaDecac

# customized prompt
PROMPT='%F{1}%n@%m%f %B%F{240}%1~%f%b %# '

# aliases
alias python='python3' # alias python to run python3
alias grep='grep --color' # use color as default for grep
alias fgrep='fgrep --color' # use color as default for fgrep
alias egrep='egrep --color' # use color as default for egrep
alias nts='cd ~/notes && ls' # to easily access notes from any directory
alias lsd='ls -d .*' # to quickly list all dot files in current directory
alias gs='git status -s' # shortcut for git status
alias lip='ifconfig | grep "inet 192.168"' # get local ip

# functions
function gd {
    git diff "$@"
}

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------


if [ -f /etc/bashrc ]; then
      . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi


#============================================================
#
#  ALIASES AND FUNCTIONS
#
#  Arguably, some functions defined here are quite big.
#  If you want to make this file smaller, these functions can
#+ be converted into scripts and removed from here.
#
#============================================================

#-------------------
# Personnal Aliases
#-------------------

case "$TERM" in
xterm*)
    # The following programs are known to require a Win32 Console
    # for interactive usage, therefore let's launch them through winpty
    # when run inside `mintty`.
    for name in node ipython php php5 psql python2.7 python python3 npm yo
    do
        case "$(type -p "$name".exe 2>/dev/null)" in
        ''|/usr/bin/*) continue;;
        esac
        alias $name="winpty $name.exe"
    done
    ;;
esac

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'


alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -lv --group-directories-first"
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}


# Creates an archive (*.tar.gz) from given directory.
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder.
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

# Make your directories and files access rights sane.
function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /etc/bash_gitprompt
export PROMPT_COMMAND=prompt_func
source /etc/bash_gitcompletion

# Handy aliases for Etsy employees
alias gist-diff='git diff origin/main | gist -p -t diff'
alias gcm='git checkout main'
alias pipe-gist='gist -p -t diff'
alias review='review --no-commit-all --stay-on-temp -g'
alias testserver='cd /tmp && python -m SimpleHTTPServer'
alias git-commit='git add -A && git commit -a'
alias git-commit-rebase='git add -A && git commit -a -m "[rebase me]"'
alias git-commit-ammend='git add -A && git commit --amend'
alias git-upstream-main='git branch --set-upstream-to=origin/main'
alias git-upstream-current='git branch --set-upstream-to=origin/$(git rev-parse --abbrev-ref HEAD)'
alias git-revert-to-main-origin='git fetch origin && git reset --hard origin/main'
alias git-revert-file='git checkout origin/main'
alias git-checkout-ticket='git branch -l | grep'
alias rpull='git rpull'
alias rtry='rpull && try'
alias gitstatus='git status'
alias git-diff-files='git diff --name-only'
alias grc='git rebase --continue'
alias make-pretty='git diff --name-only origin | grep ".js$" | xargs prettier --write'
alias superpush='until git rpull && git push; do : ; done'
alias api-compile='./bin/api/compile'
alias schema-dump='cd ~/development/SchemaDumps && git rpull'
alias pu='cd ~/development/Etsyweb/tests/phpunit/ && pake unit_nosetup'
alias pus='cd ~/development/Etsyweb/tests/phpunit/ && pake unit'
alias puf='cd ~/development/Etsyweb/tests/phpunit/ && pake unit_nosetup "'"'"'--filter'"'"'"'
alias pusf='cd ~/development/Etsyweb/tests/phpunit/ && pake unit "'"'"'--filter'"'"'"'
alias pi='cd ~/development/Etsyweb/tests/phpunit/ && pake integration_nosetup'
alias pis='cd ~/development/Etsyweb/tests/phpunit/ && pake integration'
alias pif='cd ~/development/Etsyweb/tests/phpunit/ && pake integration_nosetup "'"'"'--filter'"'"'"'
alias pisf='cd ~/development/Etsyweb/tests/phpunit/ && pake integration "'"'"'--filter'"'"'"'
alias ew='cd ~/development/Etsyweb'
alias edit-profile='vi ~/.bash_profile'
alias source-profile='source ~/.bash_profile'
alias my-vertica='vsql -h vertica-prod.etsycorp.com'
alias code-coverage='ew && bin/code-coverage/generate-local-coverage.php'

# My aliases
alias git-diff='git diff | gist -t diff'
# alias yarn='yarnpkg'
alias lah='ls -lah'
alias ....='cd .. && cd ..'
function apply-patch() {
    curl $1 | git apply -v --index
}
function yarn_prod() {
    cd ~/development/briggs/prod-npmrc/
    rm -rf node_modules package.json yarn.lock
    yarnpkg cache clean
    yarnpkg init -y
    yarnpkg add $@
    cd -
}

export GPG_TTY=$(tty)

PATH=~/.console-ninja/.bin:$PATH
alias dotfiles=/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME

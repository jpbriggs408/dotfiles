# =============================================================================
#  ZSH Configuration File
# =============================================================================

# Source common shell configuration
if [ -f "$HOME/.shell_common" ]; then
    source "$HOME/.shell_common"
fi

# oh-my-zsh Configuration
# -----------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment to change auto-update behavior
# zstyle ':omz:update' mode disabled/auto/reminder
# zstyle ':omz:update' frequency 13

source $ZSH/oh-my-zsh.sh

plugins=(
  git
  brew
  common-aliases
  node
  npm
  rand-quote
  sudo
  yarn
  z
  colored-man-pages
  colorize
  cp
  zsh-syntax-highlighting
  zsh-autosuggestions
  autojump
)


# User Configuration
# -----------------------------------------------------------------------------
# Prompt
autoload -U promptinit; promptinit
prompt pure

# Environment Variables
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home"
export PATH="$PATH:/Users/jbriggs/Library/Application Support/Coursier/bin"

# Google Cloud SDK
if [ -f '/Users/jbriggs/y/google-cloud-sdk/path.zsh.inc' ]; then 
    source '/Users/jbriggs/y/google-cloud-sdk/path.zsh.inc'
fi
if [ -f '/Users/jbriggs/y/google-cloud-sdk/completion.zsh.inc' ]; then 
    source '/Users/jbriggs/y/google-cloud-sdk/completion.zsh.inc'
fi

# Shared Aliases and Functions
# -----------------------------------------------------------------------------
# Source a shared configuration file for both bash and zsh
if [ -f "$HOME/.shell_common" ]; then
    source "$HOME/.shell_common"
fi

# ZSH-Specific Aliases and Functions
# -----------------------------------------------------------------------------
alias zshrc='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc'

# ZSH-Specific Settings
# -----------------------------------------------------------------------------
# Suffix aliases
autoload -Uz is-at-least
if is-at-least 4.2.0; then
    # open browser on urls
    if [[ -n "$BROWSER" ]]; then
        _browser_fts=(htm html de org net com at cx nl se dk)
        for ft in $_browser_fts; do alias -s $ft=$BROWSER; done
    fi

    _editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex)
    for ft in $_editor_fts; do alias -s $ft=$EDITOR; done

    if [[ -n "$XIVIEWER" ]]; then
        _image_fts=(jpg jpeg png gif mng tiff tif xpm)
        for ft in $_image_fts; do alias -s $ft=$XIVIEWER; done
    fi

    _media_fts=(ape avi flv m4a mkv mov mp3 mpeg mpg ogg ogm rm wav webm)
    for ft in $_media_fts; do alias -s $ft=mplayer; done

    #read documents
    alias -s pdf=acroread
    alias -s ps=gv
    alias -s dvi=xdvi
    alias -s chm=xchm
    alias -s djvu=djview

    #list whats inside packed file
    alias -s zip="unzip -l"
    alias -s rar="unrar l"
    alias -s tar="tar tf"
    alias -s tar.gz="echo "
    alias -s ace="unace l"

    # ----- 5.9 Global Aliases -----
    alias -g H='| head'
    alias -g T='| tail'
    alias -g G='| grep'
    alias -g L="| less"
    alias -g M="| most"
    alias -g LL="2>&1 | less"
    alias -g CA="2>&1 | cat -A"
    alias -g NE="2> /dev/null"
    alias -g NUL="> /dev/null 2>&1"
fi

# ZSH completion for SSH hosts
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Sourcing so sourcing
source /etc/zsh/zprofile

# History settings
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=3000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt NO_HIST_BEEP
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
# Use the same history file for all sessions
setopt SHARE_HISTORY
# Let the user edit the command line after history expansion (e.g. !ls) instead of immediately running it
setopt hist_verify

setopt extended_glob
setopt noequals
setopt nobeep
setopt CORRECT
setopt autocd
setopt nohup
setopt HASH_CMDS

# Don't fail on unsuccessful globbing
unsetopt NOMATCH

bindkey -v

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey "^[[2~" yank
bindkey "^[[3~" delete-char
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line
bindkey "^[[A"  up-line-or-history
bindkey "^[[B"  down-line-or-history
bindkey "^[[H"  beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[e"   expand-cmd-path
bindkey "^[[1~" beginning-of-line                      # Pos1
bindkey "^[[4~" end-of-line
bindkey " "     magic-space
bindkey "^[u"   undo
bindkey "^[r"   redo

bindkey "^R"	history-incremental-search-backward

EDITOR="vim"
XTERM="urxvtc -pe tabbed"

alias ls='ls -h --color=auto --group-directories-first'
alias flash='mount /mnt/flash'
alias df='df -m'
alias lsl='ls -hl --color=auto --group-directories-first'

alias mv='nocorrect mv -i'
alias cp='nocorrect cp -Ri'
alias rm='nocorrect rm -rI'
alias rmf='nocorrect rm -f'
alias rmrf='nocorrect rm -fR'
alias mkdir='nocorrect mkdir'

alias esync='layman -S && eix-sync -C --quiet'
alias amd64='ACCEPT_KEYWORDS="~amd64" emerge -pv'

alias pygbb="pygmentize -f bbcode"
alias imgpost="uimge -i --usr=#url#"


# Alias functions
youmplayer () { mplayer `youtube-dl -g $1` }

urlix () {
    for url in `eix -e $1 --format '<homepage>'`; do
        $BROWSER "$url" > /dev/null;
    done
}
compdef _eix urlix

# prompt
autoload -U promptinit
promptinit
prompt gentoo

# Zmv!
autoload -U zmv
# Zcalc!
autoload -U zcalc

#zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
#zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Cache completion
zstyle ':completion::complete:*' use-cache 1

# List completions
zmodload zsh/complist
#zstyle ':completion'
#zstyle ':completion:*' menu yes select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Kill processes with completion
zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*:processes-names' command 'ps xho command'
zstyle '*' hosts $hosts

# Force rehashing
_force_rehash() {
(( CURRENT == 1 )) && rehash
return 1
}

# Load forced rehash
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete


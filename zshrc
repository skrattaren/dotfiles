# Sourcing so sourcing
source /etc/zsh/zprofile

#Set LS_COLORS
if [[ -f ~/.dir_colors ]]; then
        eval `dircolors -b ~/.dir_colors`
else
        eval `dircolors -b /etc/DIR_COLORS`
fi

# History settings
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=3000
setopt append_history inc_append_history
setopt no_hist_beep
setopt hist_ignore_dups hist_ignore_all_dups hist_expire_dups_first
setopt hist_save_no_dups hist_find_no_dups
# Use the same history file for all sessions
setopt share_history
# Let the user edit the command line after history expansion (e.g. !ls) instead of immediately running it
setopt hist_verify

setopt extended_glob
setopt noequals
setopt nobeep
setopt correct
setopt autocd
setopt nohup
setopt hash_cmds

# Don't fail on unsuccessful globbing
unsetopt nomatch

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

alias ls='ls -h --color=auto --group-directories-first'
alias df='df -m'
alias lsl='ls -hl --color=auto --group-directories-first'

alias mv='nocorrect mv -i'
alias cp='nocorrect cp -Ri'
alias rm='nocorrect rm -rI'
alias rmf='nocorrect rm -f'
alias rmrf='nocorrect rm -fR'
alias mkdir='nocorrect mkdir'

# Convenient ones
alias tmux="tmux -u attach || tmux -u"
alias wget="wget --continue --content-disposition"
alias vim="vim -p"
alias grep="grep --colour"
alias feh="feh --fullscreen --scale-down --sort filename"

## Shell functions
# Watch YouTube video with Mplayer
youmplayer () { mplayer `youtube-dl -g $1` }

# Coloured and lessed diff
udiff() {
        difflength=`diff -u $1 $2 | wc -l`
        cmd="diff -u $1 $2 | pygmentize -g"
        if [[ LINES -lt difflength ]] then
            cmd="${cmd} | less"
        fi
        eval $cmd
}

# Grep current kernel config for options
krngrep() { zgrep --colour $1 /proc/config.gz }

# Open package homepage
urlix () {
    for url in `eix -e --pure-packages $1 --format '<homepage>'`; do
        $BROWSER "$url" > /dev/null;
    done
}

# Open package's ebuild in editor
ebldopen () { $EDITOR `equery which $1` }

# Open package changelog
ebldlog () { $EDITOR $(dirname `equery which $1`)/ChangeLog }

compdef "_gentoo_packages available" urlix ebldopen ebldlog

# Auto-completion from `cmd --help`
compdef _gnu_generic feh

# Complete pumount like umount
compdef _mount pumount

# Rubyless omploading
ompload() {
    curl -F file1=@"$1" http://ompldr.org/upload|awk '/Info:|File:|Thumbnail:|BBCode:/{gsub(/<[^<]*?\/?>/,"");$1=$1;sub(/^/,"\033[0;    34m");sub(/:/,"\033[0m: ");print}'
}

# Notify at
notify_at() { echo sw-notify-send "$2" "$3" | at "$1" }

# prompt
autoload -U promptinit
promptinit

# gentoovcs prompt theme
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:git:*' formats '[±:%b]'
zstyle ':vcs_info:hg:*' formats '[☿:%b]'
setopt PROMPT_SUBST

prompt_gentoovcs_help () {
  cat <<'EOF'
Standard Gentoo prompt theme with VCS info. Like original, it's color-scheme-able:

  prompt gentoovcs [<promptcolour> [<usercolour> [<rootcolour> [<vcsinfocolour>]]]]

EOF

}

prompt_gentoovcs_setup () {
  prompt_gentoo_prompt=${1:-'blue'}
  prompt_gentoo_user=${2:-'green'}
  prompt_gentoo_root=${3:-'red'}
  prompt_gentoo_vcs=${4:-'white'}
  prompt_gentoo_job=${5:-'magenta'}

  jobs="%F{$prompt_gentoo_job}%(1j. [%j] .)%f"

  if [ "$USER" = 'root' ]
  then
    base_prompt="%B%F{$prompt_gentoo_root}%m%k "
  else
    base_prompt="%B%F{$prompt_gentoo_user}%n@%m%k "
  fi
  path_prompt="%B%F{$prompt_gentoo_prompt}%1~"
  vcs_prompt='%B%F{$prompt_gentoo_vcs}${vcs_info_msg_0_:+${vcs_info_msg_0_} }'
  post_prompt="%b%f%k"

  PS1="${jobs}${base_prompt}${vcs_prompt}${path_prompt} %(0?.%#.%S%#%s) $post_prompt"
  PS2="$base_prompt$path_prompt %_> $post_prompt"
  PS3="$base_prompt$path_prompt ?# $post_prompt"

  add-zsh-hook precmd vcs_info
}

if [[ $TERM == "screen" ]] then
  prompt clint
else
  prompt_gentoovcs_setup "$@"
fi

# Zmv!
autoload -U zmv
# Zcalc!
autoload -U zcalc

# Cache completion
zstyle ':completion::complete:*' use-cache 1

# List completions
zmodload zsh/complist
zstyle ':completion:*' menu select
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


# set LS_COLORS
if [[ -f ~/.dir_colors ]]; then
    eval `dircolors -b ~/.dir_colors`
else
    eval `dircolors -b /etc/DIR_COLORS`
fi

# history settings
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=3000

setopt hist_ignore_all_dups
setopt hist_verify
setopt inc_append_history
setopt share_history
unsetopt hist_beep

setopt autocd
setopt correct
setopt extended_glob
setopt interactive_comments
unsetopt beep
unsetopt equals
unsetopt hup
unsetopt nomatch

bindkey -v

# the following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# end of lines added by compinstall

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
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey " "     magic-space
bindkey "^[u"   undo
bindkey "^[r"   redo

# a wee bitty bit of emacs
bindkey "^A"    beginning-of-line
bindkey "^E"    end-of-line
bindkey "^K"    kill-line

# alt-<> for jumping by word
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word

bindkey "^R"    history-incremental-search-backward

alias ls='ls -h --quoting-style=literal --color=auto --group-directories-first'

alias mv='mv -i'
alias cp='cp -Ri'
alias rm='rm -rI'

# convenient ones
alias tmux="tmux -u attach || tmux -u"
alias wget="wget --continue --content-disposition"
alias grep="grep --colour"
alias qmv="qmv --format=do"
alias qcp="qcp --format=do"

if hash mpv 2>/dev/null; then
    MPLAYER="mpv"
elif hash mplayer2 2>/dev/null; then
    MPLAYER="mplayer2"
else
    MPLAYER="mplayer"
fi

alias dvdplay="$MPLAYER dvd://1 -dvd-device"

# we keep full path to `feh` executable in alias for 'feh' alias not to mess
# with 'feht'
feh_base="$(which feh) -FqV --auto-rotate --sort filename \
    --font 'DejaVuSans/11' -C /usr/share/fonts/dejavu/"

alias feht="$feh_base -t"
alias feh="$feh_base -Y"
unset feh_base

# alias for eix'ing in in separate cache for remotes
alias eixr='eix --cache-file /var/cache/eix/remote.eix'
# (update eix-remote cache via cron)
# @daily /bin/bash -c 'EIX_CACHEFILE="/var/cache/eix/remote.eix" \
#        eix-remote update &> /dev/null'


## Shell functions

# `find` things easily
findhere() { find . -iname "*$1*" }

# coloured and lessed diff
udiff() {
    diff -ur $1 $2 | pygmentize -l diff | less -FRXe
}

# grep current kernel config for options
krngrep() { zgrep --colour --ignore-case $1 /proc/config.gz }

# open package homepage
urlix () {
    for url in `eix -e --pure-packages $1 --format '<homepage> '`; do
        $BROWSER "$url" &> /dev/null;
    done
}

# open package's ebuild in editor
ebldopen () { $EDITOR `equery which $1` }

compdef "_gentoo_packages available" urlix ebldopen ebldlog

# find and symlink package from overlay
lnspkg () {
    local pkg len LCLPORT LMNDIR
    LMNDIR="/var/lib/layman"
    LCLPORT="/usr/local/portage"
    pkg=($LMNDIR/*/*/$1(N))
    len=${#pkg}
    if [ "$len" -eq 0 ]; then
        echo "No package \"$1\" found in $LMNDIR" >&2
        return 1
    fi
    if [ "$len" -eq 1 ]; then
        pkgpath=(${(s:/:)pkg})
        cat=$pkgpath[5]
        echo "Creating $LCLPORT/$cat..."
        mkdir -p "$LCLPORT/$cat"
        if [ -x "$LCLPORT/$cat/$1" ]; then
            echo "$LCLPORT/$cat/$1 already exists" >&2
            return 1
        fi
        echo "Creating symlink: $LCLPORT/$cat/$1 -> $pkg"
        ln -s "$pkg" "$LCLPORT/$cat/$1"
    else
        echo "Multiple results for \"$1\" in $LMNDIR:" >&2
        echo "$pkg" >&2
        return 1
    fi
}

# digest and compile latest non-live ebuild in ./
digest_compile_latest() {
    local ebuilds latest_ebuild
    ebuilds=( ./*-^(9999).ebuild )
    if [ ${#ebuilds} -eq 0 ]; then
        echo "No non-live ebuilds in current dir" >&2
        return 1
    fi
    latest_ebuild=$ebuilds[-1]
    ebuild $latest_ebuild digest clean install
}

toggle_history() {
    if [[ -n $HISTFILE ]]; then
        unset HISTFILE
    else
        HISTFILE=~/.histfile
    fi
}

# convert and read rST document in browser
rstread() {
    local htmlfile
    htmlfile="/tmp/$(basename $1).html"
    rst2html.py $1 $htmlfile
    echo file://$htmlfile
}

# auto-completion from `cmd --help`
compdef _gnu_generic ag

# complete pumount like umount
compdef _mount pumount

# notify at
notify_at() { echo sw-notify-send "$2" "$3" | at "$1" }

# use $EDITOR to run Lua code in awesome
evawesome () {
    local EVALFILE
    EVALFILE="$HOME/.cache/awesome/eval.lua"
    $EDITOR "$EVALFILE" && cat "$EVALFILE" | awesome-client
}

# prompt
autoload -U promptinit
promptinit

setopt prompt_subst

prompt_squiggle_pp_help () {
    cat <<'EOF'
A colourful prompt, with SCM info, jobs, return code and histoff marker.
Pretty Prompt, named after Lupin Squiggle Sec'y pp
Originally it was based on Gentoo prompt.  Colour-scheme-able:

    prompt squiggle_pp [<pathcolour> [<rootcolour> [<vcsinfocolour> \
                       [<jobnumcolor> [<histmarkcolour>]]]]]

EOF
}

prompt_squiggle_pp_setup () {
    clr_path=${1:-'blue'}
    clr_root=${2:-'red'}
    clr_vcs=${3:-'green'}
    clr_job=${4:-'magenta'}
    clr_histoff=${5:-'white'}
    clr_trail=${5:-'blue'}

    jobs="%F{$clr_job}%(1j. [%j].)%f"

    if [ "$USER" = 'root' ]
    then
        base_prompt="%B%F{$clr_root}%m%k "
    else
        base_prompt="%B "
    fi

    base_prompt="%S%F{$clr_histoff}%v%s%f${base_prompt}"

    path_prompt="%F{$clr_path}%(5~|%-1~/…/%3~|%4~) "
    # FIXME: get rid of multiple '%F{$clr_vcs}]'
    vcs_prompt='%F{$clr_vcs}${vcs_info_msg_0_:+${vcs_info_msg_0_} }%f'
    post_prompt="%b%f%k "

    PS1="${jobs}${base_prompt}${path_prompt}${vcs_prompt}%B%F{$clr_trail}%(0?.%#.%S%#%s)$post_prompt"
    PS2="$base_prompt$path_prompt %_> $post_prompt"
    PS3="$base_prompt$path_prompt ?# $post_prompt"

    # vcs_info options
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git svn hg
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' unstagedstr '%U'
    zstyle ':vcs_info:hg:*' get-revision true
    zstyle ':vcs_info:hg:*' get-mq true
    zstyle ':vcs_info:hg:*' formats '[☿:%u%b%m%%u%F{$clr_vcs}]'
    zstyle ':vcs_info:hg:*' actionformats '[☿:%u%b%%u-%a%F{$clr_vcs}]'
    zstyle ':vcs_info:hg:*' branchformat '%b'
    zstyle ':vcs_info:hg:*' patch-format '+%p'
    zstyle ':vcs_info:hg:*' nopatch-format ''
    zstyle ':vcs_info:git:*' formats '[±:%u%b%%u%F{$clr_vcs}]'
    zstyle ':vcs_info:git:*' actionformats '[±:%u%b%%u|%a%F{$clr_vcs}]'

    add-zsh-hook precmd vcs_info
    add-zsh-hook precmd (){
        if [[ -z $HISTFILE ]]; then
            psvar[1]=" H "
        else
            psvar[1]=""
        fi
        print -Pn "\e]0;%~ %#\a"
        echo -ne '\a'
    }
}

if [[ $TERM == "screen" ]] then
    prompt clint
else
    prompt_squiggle_pp_setup "$@"
fi

# zmv!
autoload -U zmv
# zcalc!
autoload -U zcalc

# cache completion
zstyle ':completion::complete:*' use-cache 1

# list completions
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# kill processes with completion
zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*:processes-names' command 'ps xho command'

# fuzzy-like completion
zstyle ':completion:*' matcher-list '' 'r:|?=** m:{a-z\-}={A-Z\_}'

# force rehashing
_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1
}

# load forced rehash
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete

# load local file
if [[ -f ~/.zshlocal ]]; then
    source ~/.zshlocal
fi

# vim: softtabstop=4:shiftwidth=4

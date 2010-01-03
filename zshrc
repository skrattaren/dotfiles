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

setopt noequals
setopt nobeep
setopt CORRECT
setopt autocd
setopt nohup
setopt HASH_CMDS

# Don't fail on unsuccessful globbing
unsetopt NOMATCH

bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#compctl -c sudo

bindkey "^[[2~" yank
bindkey "^[[3~" delete-char
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
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

alias -s gz=tar -xzf
alias -s bz2=tar -xjf
alias -s txt=$EDITOR

alias ls='ls -h --color=auto --group-directories-first'
alias flash='mount /mnt/flash'
alias df='df -m'
alias lsl='ls -hl --color=auto --group-directories-first'

alias zhist='cat ~/.histfile | grep '	# grep in zsh history
alias oldlop='genlop -f /var/log/emerge.log.old -t'

alias mv='nocorrect mv -i'      # переименование-перемещение c пogтвepжgeнueм
alias cp='nocorrect cp -Ri'     # рекурсивное копирование с подтверждением
alias rm='nocorrect rm -rI'     # удаление с подтверждением
alias rmf='nocorrect rm -f'     # принудимтельное удаление
alias rmrf='nocorrect rm -fR'   # принудительное рекурсивное удаление
alias mkdir='nocorrect mkdir'   # создание каталогов без коррекции

alias esync='layman -S && eix-sync -C --quiet'
alias amd64='ACCEPT_KEYWORDS="~amd64" emerge -pv'

alias pygbb="pygmentize -f bbcode"
alias imgpost="uimge -i --usr=#url#"

alias reload_conkyrc="killall -SIGHUP conky"
alias kern_make="mv /boot/kernel-2.6.32 /boot/kernel-2.6.32_ ; make -j2 && make modules_install && cp -L arch/x86/boot/bzImage /boot/kernel-2.6.32"

# prompt
autoload -U promptinit
promptinit
prompt gentoo

#zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
#zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Кэширование дополнений
zstyle ':completion::complete:*' use-cache 1

# Выбор вариантов в виде меню с подсветкой текущего варианта
zmodload zsh/complist
#zstyle ':completion'
#zstyle ':completion:*' menu yes select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# По умолчанию автодополнение для kill и killall не показывает процессы без controlling tty
# (для всех пользователей кроме root).
# Устраняем этот недостаток и дополнительно добавляем «красоты».
zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*:processes-names' command 'ps xho command'
zstyle '*' hosts $hosts

# Принудительное обновление списка команд для дополнения
_force_rehash() {
(( CURRENT == 1 )) && rehash
return 1
}
# Подгружаем это дело           
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete

# вместо cd /path/to/file вводим лишь путь
setopt autocd



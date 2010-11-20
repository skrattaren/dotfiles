#!/bin/sh

# "Deploys" this config pack,
# i.e. symlink config files to those in this repo
# backing up existing files etc.

RDIR=$(dirname `readlink -fn $0`)

excludes="deploy.sh green_kde.colors ir_black_cscheme.vim"

function include() {
    for i in ${excludes[@]}; do
        if [ "$i" == "$1" ]; then
            return 1
        fi
    done
    return 0
}

function symlinkit() {
    SRC="$1"
    TRGT="$2"
    if [ -L "$TRGT" ]; then
            echo "Removing old symlink $TRGT..."
        rm "$TRGT"
    elif [ -e "$TRGT" ]; then
        if [ -e "$TRGT"~ ]; then
            echo "Both $TRGT and $TRGT~ exist, skipping..."
            return
        fi
        echo "Backing up $TRGT to $TRGT~"
        mv "$TRGT" "$TRGT"~
    fi
    ln -s "$SRC" "$TRGT"
}

if [[ $EUID -ne 0 ]]; then
    symlinkit "$RDIR/green_kde.colors" \
        "$HOME/.kde4/share/apps/color-schemes/green_kde.colors"
    FILES=$(ls "$RDIR")
else
    FILES="vimrc zshrc"
fi

VIMCSDIR="$HOME/.vim/colors"
if [ ! -d "$VIMCSDIR" ]; then
    mkdir -p "$VIMCSDIR"
fi
symlinkit "$RDIR/ir_black_cscheme.vim" "$VIMCSDIR/ir_black.vim"

for f in "$FILES"; do
    if include "$f"; then
        symlinkit "$RDIR/$f" "$HOME/.$f"
    fi
done


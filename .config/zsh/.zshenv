#!/bin/zsh
ZDOTDIR=~/.config/zsh/

# Adds `~/.local/bin` to $PATH
export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')"

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"

# ~/ Clean up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_VIDEOS_DIR="$HOME/Videos"

export SVDIR="$XDG_DATA_HOME/service"

export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/X11/xinitrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go:${XDG_DATA_HOME:-$HOME/.local/share}/mygo"
export CONDARC="${XDG_CONFIG_HOME:-$HOME/.config}/conda/condarc"
export GNUPGHOME="${XDG_CONFIG_HOME:-$HOME/.config}/gnupg"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia_depot:$JULIA_DEPOT_PATH"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wgetrc"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export ANDROID_HOME="$XDG_DATA_HOME"/android
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export MATHEMATICA_USERBASE="$XDG_CONFIG_HOME"/mathematica
export REDISCLI_HISTFILE="$XDG_DATA_HOME"/redis/rediscli_history
export VAGRANT_HOME="$XDG_DATA_HOME"/vagrant
export WINEPREFIX="$XDG_DATA_HOME"/wine

export WINIT_X11_SCALE_FACTOR=1.66
# export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"

# Add to PATH
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$CARGO_HOME/bin"
export PATH="$PATH:${XDG_DATA_HOME:-$HOME/.local/share}/julia/bin"
export PATH="$PATH:${XDG_DATA_HOME:-$HOME/.local/share}/MATLAB/R2021b/bin"

# Other program settings:
export FZF_DEFAULT_OPTS="--layout=reverse --height=20"
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in bspwm/dwm
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export TDESKTOP_USE_GTK_FILE_DIALOG=1
export eGTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export NO_AT_BRIDGE=1

# Clean up aliases
# alias mbsync=mbsync -c "$XDG_CONFIG_HOME"/isync/mbsyncrc
alias monerod=monerod --data-dir "$XDG_DATA_HOME"/bitmonero

# This is the list for lf icons:
export LF_ICONS="di=📁:\
fi=📃:\
tw=🤝:\
ow=📂:\
ln=⛓:\
or=❌:\
ex=🎯:\
*.txt=✍:\
*.mom=✍:\
*.me=✍:\
*.ms=✍:\
*.png=🖼:\
*.webp=🖼:\
*.ico=🖼:\
*.jpg=📸:\
*.jpe=📸:\
*.jpeg=📸:\
*.gif=🖼:\
*.svg=🗺:\
*.tif=🖼:\
*.tiff=🖼:\
*.xcf=🖌:\
*.html=🌎:\
*.xml=📰:\
*.gpg=🔒:\
*.css=🎨:\
*.pdf=📚:\
*.djvu=📚:\
*.epub=📚:\
*.csv=📓:\
*.xlsx=📓:\
*.tex=📜:\
*.md=📘:\
*.r=📊:\
*.R=📊:\
*.rmd=📊:\
*.Rmd=📊:\
*.m=📊:\
*.mp3=🎵:\
*.opus=🎵:\
*.ogg=🎵:\
*.m4a=🎵:\
*.flac=🎼:\
*.mkv=🎥:\
*.mp4=🎥:\ *.webm=🎥:\ *.mpeg=🎥:\ *.avi=🎥:\
*.zip=📦:\
*.rar=📦:\
*.7z=📦:\
*.tar.gz=📦:\
*.z64=🎮:\
*.v64=🎮:\
*.n64=🎮:\
*.gba=🎮:\
*.nes=🎮:\
*.gdi=🎮:\
*.1=ℹ:\
*.nfo=ℹ:\
*.info=ℹ:\
*.log=📙:\
*.iso=📀:\
*.img=📀:\
*.bib=🎓:\
*.ged=👪:\
*.part=💔:\
*.torrent=🔽:\
*.jar=♨:\
*.java=♨:\
"

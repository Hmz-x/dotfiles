# Misc
alias yni='yay --removemake --cleanmenu=false --noconfirm -S' # yay non-interactive install
alias cdd='builtin cd "${HOME}/.local/dotfiles"'
alias tb='nc termbin.com 9999'
alias md='xrandr --output HDMI-1 --same-as eDP-1' # mirror display on X
alias shwgpu="sudo lspci -v -s $(lspci | grep -i vga | awk '{print $1}')"
alias ocon='sudo openconnect --protocol=anyconnect --user=hmumcu --server=webvpn2.purdue.edu' #openconnect
alias yu='yay --noconfirm -Syu'
alias umnt='sudo umount /mnt/usb'

# General cmds
alias t='tmux attach'
alias c='clear'
alias e='exit'
alias l='less'
alias z='zathura'
alias ls="ls --color=auto"

# qtile
alias vqc='lvim "${HOME}/.config/qtile/config.py"'     # vim qtile config
alias cql='cat "${HOME}/.local/share/qtile/qtile.log"' # cat qtile log
alias rqc='qtile cmd-obj -o cmd -f reload_config'      # reload qtile config

# NM/nmcli
alias rnm='sudo systemctl restart NetworkManager'
alias wscan='nmcli dev wifi rescan && nmcli dev wifi list'
alias wshow='nmcli connection show'

# git
alias ga='git add'
alias gc='git commit -m'
alias gp='git push -u origin master'
alias gs='git status'
alias gl='git log'
alias gr='git rm'

#!/bin/sh

export PATH="${PATH}:${HOME}/.local/bin/misc"
export PATH="${PATH}:${HOME}/.local/bin/WM"

[ -n "$(command -v qt6ct)" ] && export QT_QPA_PLATFORMTHEME=qt6ct

# source shell rc
shell_rc="${HOME}/.bashrc"
. "$shell_rc"

#!/bin/sh

export PATH="${PATH}:${HOME}/.local/bin/misc"
export PATH="${PATH}:${HOME}/.local/bin/WM"

# source shell rc
shell_rc="${HOME}/.bashrc"
. "$shell_rc"

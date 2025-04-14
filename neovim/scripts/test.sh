#!/usr/bin/env sh

#
# Assert nvim config is applied without rebuild
#

DIR="$(dirname "$0")"/..

# set up

NVIM=${DIR}/result/bin/nvim
CONFIG=${DIR}/configs/nvim/init.lua
BACKUP=/tmp/zga6w-config

nix build .#nvim-mutable
cp -a "$CONFIG" "$BACKUP"

# perform

echo 'vim.opt.number = false' >> "$CONFIG"
${NVIM} --headless -c 'set number?' +q | grep -q '\bnumber\b'
BEFORE=$?

echo 'vim.opt.number = true' >> "$CONFIG"
${NVIM} --headless -c 'set number?' +q | grep -q '\bnumber\b'
AFTER=$?

cp -a $BACKUP "$CONFIG"

# assert

test "$BEFORE" != "$AFTER"

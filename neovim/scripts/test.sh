#!/usr/bin/env sh

#
# Assert nvim config is applied without rebuild
#

cd "$(dirname "$0")"
cd ..

NVIM=./result/bin/nvim
CONFIG=./nvim/init.lua
BACKUP=/tmp/zga6w-config

nix build .#nvim-mutable
cp -a "$CONFIG" "$BACKUP"

#

echo 'vim.opt.number = false' >> $CONFIG
${NVIM} --headless -c 'set number?' +q | grep -q '\bnumber\b'
BEFORE=$?

echo 'vim.opt.number = true' >> $CONFIG
${NVIM} --headless -c 'set number?' +q | grep -q '\bnumber\b'
AFTER=$?

cp -a $BACKUP $CONFIG

test "$BEFORE" != "$AFTER"

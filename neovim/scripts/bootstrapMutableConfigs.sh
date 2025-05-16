#!/usr/bin/env sh

echo Make a symlink outside of the nix store...
echo It will contain links to nvim config directories

set -e
cd "$(dirname "$0")"
SCRIPTS=$(pwd)

cd ..

LINK_FILE=./configsLink.nix

set +e
LINK_NAME=$(cut -d\" -f 2 "$LINK_FILE")
LINK_TARGET=$(cd ./configs; pwd)
set -e

# assure LINK_NAME is an existing directory
if test ! -d "$LINK_NAME"; then
  LINK_NAME=~/.local/state/yjz6v-nvim-configs
  echo \"$LINK_NAME\" > "$LINK_FILE"
fi

ln -vsfT "$LINK_TARGET" "$LINK_NAME"

echo DONE

if test "$1" = "--skiptest"; then
  exit
fi

echo
echo Test if config changes are applied without rebuilding nvim...

set +e
"$SCRIPTS/test.sh"
RESULT=$?
if test "$RESULT" -eq 0; then
  echo OK
else echo FAIL; fi

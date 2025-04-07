#!/usr/bin/env sh

echo Make a symlink outside of the nix store...

set -e
cd "$(dirname "$0")"
SCRIPTS=$(pwd)

cd ..

LINK=$(cat ./configLink.nix | cut -d\" -f 2)

cd ./nvim
ln -vsfT $(pwd) $LINK

echo DONE

if test "$1" == "--skiptest"; then
  exit
fi

echo
echo Test if config changes are applied without rebuilding nvim...

set +e
$SCRIPTS/test.sh
RESULT=$?
if test "$RESULT" -eq 0; then
  echo OK
else echo FAIL; fi

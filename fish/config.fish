# To set up user defined PATH elements
# use universal variable $fish_user_path
# see https://fishshell.com/docs/current/tutorial.html#tut_path

# Path
#
fish_add_path ~/opt/bin ~/opt/node_packages/node_modules/.bin

# HiDPI
#
set -Ux GDK_SCALE 2

# Nix
#
fish_add_path /nix/var/nix/profiles/per-user/shovel/profile/bin
set -x --unpath NIX_PATH (string join ':' \
  home-manager=/home/shovel/.nix-defexpr/channels/home-manager \
  nixpkgs=/home/shovel/.nix-defexpr/channels/nixpkgs)

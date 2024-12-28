# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be astuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  xray = import ./xray.nix;
}

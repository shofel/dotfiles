#
# https://search.nixos.org/options
#
# Used for inspiration and for copy-paste:
#   - https://github.com/angristan/nixos-config/blob/master/configuration.nix
#

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [
    pkgs.fishPlugins.forgit
  ];

  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = true;
}

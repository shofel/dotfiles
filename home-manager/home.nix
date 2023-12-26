# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "slava";
    homeDirectory = "/home/slava";
  };

  home.packages = let
    # TODO extract `system`
    pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."x86_64-linux";
  in [
    pkgs.fd
    pkgs.gh
    pkgs.jq
    pkgs.ripgrep
    pkgs.sd
    pkgs.tealdeer

    pkgs.htop
    pkgs.xclip
    pkgs.scrot
    
    pkgs-unstable.helix

    (pkgs.nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" ];
    })
  ];

  # git {{{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Slava";
    userEmail = "visla.vvi@gmail.com";

    delta = {
      enable = true;
      # TODO theme for delta
      # options = { syntax-theme = bat-catppucin-frappe; };
    };

    extraConfig = {
      init = { defaultBranch = "master"; };
      diff = { submodule = "log"; };
      submodule = { recurse = true; };
      pull = { rebase = true; };
      push = {
        autoSetupRemote = true;
        default = "current";
      };
      core = { editor = "nvim"; };
    };

    ignores = [ ".DS_Store" "*.sw?" ];
  };
  # git }}}

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

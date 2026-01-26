# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.xray

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      (import ../neovim/neovim-overlay.nix {inherit inputs;})
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # hack for command-not-found
  # @see https://blog.nobbz.dev/2023-02-27-nixos-flakes-command-not-found/
  environment.etc."programs.sqlite".source = inputs.programsdb.packages.${pkgs.stdenv.hostPlatform.system}.programs-sqlite;
  programs.command-not-found.dbPath = "/etc/programs.sqlite";

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = ["nix-command" "flakes"];
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    trusted-users = ["root" "slava"];
    # Workaround for https://github.com/NixOS/nix/issues/9574
    nix-path = config.nix.nixPath;
  };

  # In hope for easier python
  programs.nix-ld.enable = true;

  networking.networkmanager.enable = true;
  networking.nameservers = ["9.9.9.9" "149.112.112.112"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.fish.enable = true;
  environment.sessionVariables = {
    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    ];
  };

  hardware.keyboard.qmk.enable = true;

  users.users = {
    slava = {
      isNormalUser = true;
      description = "slava";
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = ["networkmanager" "wheel" "docker" "dialout"];
    };
    nixosvmtest = {
      isSystemUser = true;
      initialPassword = "test";
      group = "nixosvmtest";
    };
  };

  users.groups.nixosvmtest = {};

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      # Import your home-manager configuration
      slava = import ../home-manager/home.nix;
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  # Set your time zone.
  services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "C.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "C.UTF-8";
    LC_IDENTIFICATION = "C.UTF-8";
    LC_MEASUREMENT = "C.UTF-8";
    LC_MONETARY = "C.UTF-8";
    LC_NAME = "C.UTF-8";
    LC_NUMERIC = "C.UTF-8";
    LC_PAPER = "C.UTF-8";
    LC_TELEPHONE = "C.UTF-8";
    LC_TIME = "C.UTF-8";
  };

  services.kmscon = {
    enable = true;
    hwRender = true;
  };

  # Enable X server (required for GDM, XWayland compatibility, and GNOME)
  # GNOME uses Wayland by default, but X server infrastructure is still needed
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  # FIXME
  services.displayManager.gdm.settings = {
    autologin = {
      enable = true;
      user = "nixosvmtest";
    };
  };
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  # temporary hacks?
  #

  # mount ntfs volumes
  # environment.etc."udisks2/mount_options.conf".text = ''
  #   [defaults]
  #   ntfs_defaults=uid=$UID,gid=$GID,prealloc
  # '';

  virtualisation = {
    docker.enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}

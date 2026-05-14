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

    # command-not-found replacement (with `,` to run without installing)
    inputs.nix-index-database.nixosModules.nix-index
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

  # command-not-found replacement
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

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

  programs.captive-browser = {
    enable = true;
    interface = "wlp3s0";
    # Captive portals often withhold DNS until login, causing fgrep to exit 1.
    # Fall back to the gateway IP, which serves as the portal's DNS.
    dhcp-dns = "${pkgs.networkmanager}/bin/nmcli dev show wlp3s0 | ${pkgs.gnugrep}/bin/fgrep IP4.DNS || ${pkgs.networkmanager}/bin/nmcli dev show wlp3s0 | ${pkgs.gnugrep}/bin/fgrep IP4.GATEWAY";
    browser = let
      script = pkgs.writeShellScript "captive-firefox" ''
        TMPPROFILE=$(mktemp -d)
        IFS=: read -r SOCKS_HOST SOCKS_PORT <<< "$PROXY"
        printf \
          'user_pref("network.proxy.type", 1);\nuser_pref("network.proxy.socks", "%s");\nuser_pref("network.proxy.socks_port", %s);\nuser_pref("network.proxy.socks_remote_dns", true);\n' \
          "$SOCKS_HOST" "$SOCKS_PORT" > "$TMPPROFILE/user.js"
        exec firefox --no-remote --profile "$TMPPROFILE" http://neverssl.com
      '';
    in "${script}";
  };

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
      extraGroups = ["networkmanager" "wheel" "dialout" "docker"];
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

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="net", KERNEL=="wlp3s0", RUN+="${pkgs.iw}/bin/iw dev wlp3s0 set power_save off"
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  services.logind.settings.Login.HandleLidSwitch = "ignore";

  time.timeZone = "UTC";

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

  # Disable LDAC: fatally fails to initialize on some TWS earbuds
  # (e.g., Redmi Buds 6 Pro), leaving the sink silent.
  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
      "bluez5.codecs" = [ "sbc" "sbc_xq" "aac" "aptx" "aptx_hd" ];
    };
  };

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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  virtualisation.docker.enable = true;

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 4096;
    randomEncryption.enable = true;
    options = ["discard"];
  }];
  boot.kernel.sysctl."vm.swappiness" = 10;
}

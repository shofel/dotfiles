# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Yekaterinburg";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus10";
    keyMap = "dvorak";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.stumpwm.enable = true;

    xkbVariant = "dvorak";
    xkbOptions = "ctrl:nocaps";
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Shell for all users.
  environment.binsh = "${pkgs.dash}/bin/dash";

  programs.ssh.startAgent = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shovel = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.users.shovel = { pkgs, ... }: {
    home.packages = with pkgs; [ htop kitty gh bat fd ripgrep ];

    home.homeDirectory = "/home/shovel";

    programs.git = {
      enable = true;
      userName = "Slava";
      userEmail = "visla.vvi@gmail.com";
    };

    programs.command-not-found.enable = true;

    # Links to the dotfiles
    # home.file.".config/nvim/init.vim".source = "/home/shovel/w/dotfiles/nvim/init.vim";

    # NeoVim
    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;

      plugins = with pkgs.vimPlugins; [
        # tpope 
        vim-commentary
        vim-dispatch
        vim-eunuch
        vim-fugitive
        vim-projectionist
        vim-repeat
        vim-rsi
        vim-sleuth
        vim-surround
        vim-unimpaired
      ];
    };

    # Fish

    home.file.".config/fish/functions" = {
      source = /home/shovel/w/dotfiles/fish/functions;
      recursive = true;
    };

    programs.fish.enable = true;

    programs.fish.shellAbbrs = {
      dc = ''docker-compose'';
      execlip = "fish -c (xclip -o)";
      # git
      gB = "git switch (git fetch --all 1>/dev/null ;and git branch --all | string replace 'remotes/origin/' '' | string trim | sort | uniq | fzf)";
      gb = "git switch (git branch | string trim | fzf)";
      gBFG = "git for-each-ref --format '%(refname:short)' refs/heads | grep -v master | xargs git branch -D";
      ga = "git add";
      gamend = "git commit --amend --no-edit";
      gcb = "git switch -c";
      gcd = "cd (git rev-parse --show-toplevel)";
      gclean = "git clean -fd";
      gcom = "git commit";
      gd = "git diff";
      gdca = "git diff --cached";
      gfa = "git fetch --all --prune --tags";
      ghash = "git rev-parse --short HEAD";
      ginit = "git init ;and git commit -m 'root' --allow-empty";
      gl = "git pull";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gpu = "echo git push -u origin (git branch | grep \* | awk \"{print \$2}\")";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      grbs = "git rebase --skip";
      gsm = "git switch master";
      gst = "git status --short --branch";
      gsw = "git switch";
      #
      r  = "sudo nixos-rebuild switch";
      #
      nocaps = "setxkbmap -option ctrl:nocaps";
      suspend = "systemctl suspend";
      v = "nvim '+Term fish'";
      weather = "curl wttr.in/guangzhou";
    };

    services.redshift = {
      enable = true;
      latitude = 56.83;
      longitude = 60.60;
      temperature = { day = 6500; night = 3000; };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    x11_ssh_askpass
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # VirtualBox
  # nixpkgs.config.allowUnfree = true;
  # virtualisation.virtualbox.guest.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  # Some other custom stuff

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 8d";
}


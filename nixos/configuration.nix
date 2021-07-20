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
    home.packages = with pkgs; [
      bat fd ripgrep
      gh
      nixfmt
    ];

    home.homeDirectory = "/home/shovel";

    programs.git = {
      enable = true;
      userName = "Slava";
      userEmail = "visla.vvi@gmail.com";
    };

    programs.command-not-found.enable = true;

    # Links to the dotfiles
    xdg.enable = true;
    # home.file.".config/nvim/init.vim".source = "/home/shovel/w/dotfiles/nvim/init.vim";

    # Kitty
    xdg.configFile."kitty/startup_session".source = ../kitty/startup_session;
    xdg.configFile."kitty/empty_session".source = ../kitty/empty_session;
    programs.kitty = {
      enable = true;

      font = {
        package = pkgs.fira-code;
        name = "Fira Code";
        size = 11;
      };

      settings = {
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";

        clear_all_shortcuts = "yes";

        # Tab bar
        # @see https://sw.kovidgoyal.net/kitty/conf.html#tab-bar
        "tab_bar_edge" = "top";
        "tab_bar_style" = "powerline";
        "tab_powerline_style" = "slanted";
        #
        "tab_bar_min_tabs" = "1";
        "tab_title_template" = "{index} {title}";
        #
        "tab_bar_background" = "#bbb";
        "active_tab_foreground" = "#222";
        "active_tab_background" = "#faf8f5";
        "active_tab_font_style" = "normal";
        "inactive_tab_foreground" = "#444";
        "inactive_tab_background" = "#bbb";
        "inactive_tab_font_style" = "normal";

        # Misc
        "cursor_blink_interval" = "0";

        # Colors
        #
        "background_opacity" = "1.0";
        "dynamic_background_opacity" = "no";
        # special
        "foreground" = "#8c6923";
        "background" = "#faf8f5";
        # black
        "color0" = "#000000";
        "color8" = "#4d4d4d";
        # red
        "color1" = "#e06c75";
        "color9" = "#e06c75";
        # green
        "color2" = "#98c379";
        "color10" = "#98c379";
        # yellow
        "color3" = "#e5c07b";
        "color11" = "#e5c07b";
        # blue
        "color4" = "#61afef";
        "color12" = "#61afef";
        # magenta
        "color5" = "#c678dd";
        "color13" = "#c678dd";
        # cyan
        "color6" = "#56b6c2";
        "color14" = "#56b6c2";
        # white
        "color7" = "#737780";
        "color15" = "#a1a7b3";
      };

      keybindings = {
        ## Keys: Tabs {{{
        "ctrl+space>t" = "new_tab";
        "ctrl+space>r" = "set_tab_title";
        "ctrl+space>k>k" = "close_tab";

        "ctrl+space>shift+l" = "move_tab_forward";
        "ctrl+space>shift+h" = "move_tab_backward";
        "ctrl+space>l" = "next_tab";
        "ctrl+space>h" = "previous_tab";

        ## Switch tabs with Leader > number
        "ctrl+space>1" = "goto_tab 1";
        "ctrl+space>2" = "goto_tab 2";
        "ctrl+space>3" = "goto_tab 3";
        "ctrl+space>4" = "goto_tab 4";
        "ctrl+space>5" = "goto_tab 5";
        "ctrl+space>6" = "goto_tab 6";
        "ctrl+space>7" = "goto_tab 7";
        "ctrl+space>8" = "goto_tab 8";
        "ctrl+space>9" = "goto_tab 9";
        # }}} Tabs

        # Copy and paste
        "ctrl+space>y" = "copy_to_clipboard";
        "ctrl+space>p" = "paste_from_clipboard";
        "ctrl+space>shift+p" = "paste_from_selection";

        # scroll
        "ctrl+space>s" = "show_scrollback";

        # font size
        "ctrl+space>up" = "change_font_size all +4";
        "ctrl+space>down" = "change_font_size all -4";
        "ctrl+space>right" = "change_font_size all  0";

        # Open kitty shell in window/tab/overlay/os_window
        "ctrl+space>;" = "kitty_shell overlay";

        # Reload kitty.conf
        "ctrl+space>shift+r" = "load_config_file";
        # }}} keys
      };
    };


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


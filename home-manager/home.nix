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
    inputs.nix-colors.homeManagerModules.default

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
      inputs.nvim.overlays.default

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

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-frappe;

  home = {
    username = "slava";
    homeDirectory = "/home/slava";
  };

  home.packages = let
    # TODO extract `system`
    pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages."x86_64-linux";
  in [
    # Modern and fancy
    pkgs.fd # find
    pkgs.ripgrep
    pkgs.sd # sed

    pkgs.tealdeer
    pkgs.gh
    pkgs.jq

    pkgs.htop
    pkgs.xclip
    pkgs.scrot

    pkgs-unstable.helix
    pkgs-unstable.kitty
    pkgs.devenv

    (pkgs.nerdfonts.override {
      fonts = [ "FiraCode" "DroidSansMono" ];
    })

    pkgs.firefox
    pkgs.onlyoffice-bin

    pkgs.nvim-shovel
  ];

  fonts.fontconfig.enable = true;

  # {{{ fzf
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  # }}} fzf

  # {{{ bat
  programs.bat = {
    enable = true;
    config = {
      map-syntax = [ "*.json5:JavaScript (Babel)" ];
      style = "numbers";
      theme = "catppuccin";
    };
    themes = {
      catppuccin = {
        src = inputs.catppuccin-bat;
        file = "themes/Catppuccin Frappe.tmTheme";
      };
    };
  };
  # }}} bat

  # git {{{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Slava";
    userEmail = "visla.vvi@gmail.com";

    delta = {
      enable = true;
      options = { syntax-theme = "catppuccin"; }; # see `bat.themes`
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

    ignores = [ ".DS_Store" "*.sw?" "__pycache__" ];
  };

  programs.lazygit = {
    enable = true;
    settings = {
      # @see from github:catppuccin/lazygit
      gui = {
        theme = let
          color = x: "#${builtins.getAttr x config.colorScheme.palette}";
        in {
          activeBorderColor          = [ (color "base0B") "bold" ];
          inactiveBorderColor        = [ (color "base05") ];
          searchingActiveBorderColor = [ (color "base0F") ];
          optionsTextColor           = [ (color "base0D") ];
          selectedLineBgColor        = [ (color "base02") "default" ];
          selectedRangeBgColor       = [ (color "base02") ];
          cherryPickedCommitBgColor  = [ (color "base0C") ];
          cherryPickedCommitFgColor  = [ (color "base0D") ];
          unstagedChangesColor       = [ (color "base0A") ];
          defaultFgColor             = [ (color "base05") ];
        };
      };
    };
  };
  # }}} git

  # ssh {{{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519

      Host tropical
        Hostname 138.124.103.185
        User root
        IdentityFile ~/.ssh/id_aeza_tropical
    '';
  };
  # }}} ssh

  programs.direnv = {
    enable = true;
  };

  # kitty {{{
  xdg.configFile."kitty/kitty.conf" = let
    conf = builtins.readFile ./kitty/kitty.conf;
    colors = builtins.readFile
      "${inputs.catppuccin-kitty}/themes/frappe.conf";
    session = "startup_session ./startup_session";
  in { text = conf + "\n" + colors + session; };

  # fish -lc is to setup env
  xdg.configFile."kitty/startup_session".text = ''
    new_tab dotfiles
    cd ~/workspaces-one/dotfiles/
    launch fish -lc nvim

    new_tab kbd
    cd ~/workspaces-one/keyboards/
    launch fish -lc nvim

    new_tab shovel-qr
    cd ~/workspaces-one/30-portfolio/30.01-django-qr/
    launch fish -lc nvim
  '';

  xdg.configFile."kitty/empty_session".text = ''
    new_tab tab
    cd
    launch fish -lc nvim
  '';
  # }}} kitty

  # stumpwm {{{
  xdg.configFile."stumpwm" = {
    source = ./stumpwm;
    recursive = true;
  };
  # }}} stumpwm

  # fish {{{
  xdg.configFile."fish/functions" = {
    source = ./fish/functions;
    recursive = true;
  };

  programs.fish = {
    enable = true;

    plugins = [ ];

    interactiveShellInit = ''
      set -gx XCURSOR_THEME Adwaita
    '';
    loginShellInit = '''';

    # shellAbbrs {{{
    shellAbbrs = {
      dc = "docker-compose";

      # @from https://ploegert.gitbook.io/til/tools/git/switch-to-a-recent-branch-with-fzf
      gb = ''
        git switch (
          git for-each-ref --sort=-committerdate refs/heads/ \
            --format="%(refname:short)" \
          | string trim \
          | fzf)'';

      gBFG =
        "git for-each-ref --format '%(refname:short)' refs/heads | grep -v master | xargs git branch -D";

      ga = "git add";

      gamend = "git commit --amend --no-edit";
      gcom = "git commit";

      gfa = "git fetch --all --prune --tags";
      gpf = "git push --force-with-lease";
      gpu = "git push -u origin HEAD";

      gtop = "git rev-parse --show-toplevel";
      gcd = "cd (git rev-parse --show-toplevel)";
      ghash = "git rev-parse --short HEAD";
      gclean = "git clean -fd";

      ginit = "git init ;and git commit -m 'root' --allow-empty";

      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      grbs = "git rebase --skip";

      gsm = "git switch master";
      gst = "git status --short --branch";

      #
      suspend = "systemctl suspend";
      v = "nvim '+Term fish'";
      weather = "curl wttr.in/guangzhou";
    };
    # }}} shellAbbrs

  }; # }}} fish

  # redshift {{{
  services.redshift = {
    enable = true;
    latitude = 41.0;
    longitude = 29.0;
    temperature = {
      day = 6500;
      night = 3000;
    };
  };
  # }}} redshift

  # {{{ shadowsocks client
  systemd.user.services.sslocal = {
    Unit.Description = "Shadowsocks-rust sslocal client";

    # TODO manage the config file
    # TODO liveness probe
    Service = {
      ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal -c /home/slava/workspaces-one/33-orange-hosting/ssclient.json";
      SyslogIdentifier = "shadowsocks-rust.sslocal";
      Restart = "on-failure"; ## TODO
      TimeoutStopSec = 30;
      Type = "simple";
    };

    Install.WantedBy = [ "default.target" ];
  };
  # }}} shadowsocks

  #
  programs.home-manager.enable = true;
  programs.command-not-found.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

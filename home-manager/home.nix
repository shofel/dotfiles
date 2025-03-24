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

      #
      (import ../neovim/neovim-overlay.nix {inherit inputs;}) 

      # Or define it inline
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
      core.editor = "nvim";
      core.quotePath = false;
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
    nix-direnv.enable = true;
  };

  # kitty {{{
  xdg.configFile."kitty/kitty.conf" = let
    conf = builtins.readFile ./kitty/kitty.conf;
    colors = builtins.readFile
      "${inputs.catppuccin-kitty}/themes/frappe.conf";
    session = "startup_session ./startup_session";
  in {
    text = builtins.concatStringsSep "\n" [
      conf colors session
    ];
  };

  # fish -lc is to setup env
  xdg.configFile."kitty/startup_session".text = /* bash */ ''
    new_tab dotfiles
    cd ~/workspaces-one/25-dotfiles/25.01-dotfiles/
    launch fish -lc nvim

    new_tab nvim
    cd ~/workspaces-one/25-dotfiles/25.02-nvim-flake/
    launch fish -lc nvim

    new_tab cantor
    cd ~/workspaces-one/keyboards/
    launch fish -lc nvim

    new_tab go
    cd ~/workspaces-one/34-courses/34.01-practicum-go/
    launch fish -lc nvim
  '';

  xdg.configFile."kitty/empty_session".text = /* bash */ ''
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
      lg = "lazygit";

      # @from https://ploegert.gitbook.io/til/tools/git/switch-to-a-recent-branch-with-fzf
      gb = /* bash */ ''
        git switch (
          git for-each-ref --sort=-committerdate refs/heads/ \
            --format="%(refname:short)" \
          | string trim \
          | fzf)'';

      gBFG = /* bash */
        "git for-each-ref --format '%(refname:short)' refs/heads | grep -v master | xargs git branch -D";

      ga = /* bash */ "git add";

      gamend = /* bash */ "git commit --amend --no-edit";
      gcom = /* bash */ "git commit";

      gfa = /* bash */ "git fetch --all --prune --tags";
      gpf = /* bash */ "git push --force-with-lease";
      gpu = /* bash */ "git push -u origin HEAD";

      gtop = /* bash */ "git rev-parse --show-toplevel";
      gcd = /* bash */ "cd (git rev-parse --show-toplevel)";
      ghash = /* bash */ "git rev-parse --short HEAD";
      gclean = /* bash */ "git clean -fd";

      ginit = /* bash */ "git init ;and git commit -m 'root' --allow-empty";

      grba = /* bash */ "git rebase --abort";
      grbc = /* bash */ "git rebase --continue";
      grbs = /* bash */ "git rebase --skip";

      gsm = /* bash */ "git switch master";
      gst = /* bash */ "git status --short --branch";

      #
      suspend = /* bash */ "systemctl suspend";
      v = /* bash */ "nvim '+Term fish'";
      weather = /* bash */ "curl -s wttr.in/valencia";
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

  #
  programs.home-manager.enable = true;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

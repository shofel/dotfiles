{ config, pkgs, lib, ... }:

#       man page: Man home-configuration.nix
# search options: https://mipmip.github.io/home-manager-option-search/
#
# <leader>r to rebuild configuration and switch
#
# TODO kmonad

let bat-theme = "Monokai Extended Light";
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.command-not-found.enable = true;

  # home.packages {{{
  home.packages = let
    main = with pkgs; [
      gh
      fd
      ripgrep

      htop
      ssh-askpass-fullscreen

      rnix-lsp
      nixfmt
    ];
    node = with pkgs.nodePackages; [
      vim-language-server
      vscode-langservers-extracted
      yaml-language-server
    ];
  in main ++ node;
  # }}} home.packages

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      map-syntax = [ "*.json5:JavaScript (Babel)" ];
      style = "numbers";
      theme = bat-theme;
    };
  };

  # git {{{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Slava";
    userEmail = "visla.vvi@gmail.com";

    delta = {
      enable = true;
      options = { syntax-theme = bat-theme; };
    };

    extraConfig = {
      pull = { rebase = true; };
      core = {
        editor = "nvim";
        excludesfile = "/home/shovel/.config/git/gitignore_global";
      };
    };
  };
  # }}} git 

  # kitty
  home.file.".config/kitty" = {
    source = ./kitty;
    recursive = true;
  };

  # stumpwm
  home.file.".config/stumpwm" = {
    source = ./stumpwm;
    recursive = true;
  };

  # starship {{{
  programs.starship = {
    enable = false;
    enableFishIntegration = false;
    settings = {
      add_newline = false;
      scan_timeout = 10;
      nix_shell = { format = "[\\[nix\\]](blue) "; };

      git_branch = { format = "[$symbol$branch](bold purple)"; };
      git_status = {
        style = "bold red";
        format = lib.concatStrings [
          "["
          "$conflicted"
          "$deleted"
          "$renamed"
          "$modified"
          "$staged"
          "$untracked"

          "$ahead$ahead_count"
          "$behind$behind_count"
          "]"
          "($style)"
        ];
        ahead = "↑";
        behind = "↓";
        diverged = "⇅";
        stashed = "";
      };

      directory = {
        style = "bold green";
        fish_style_pwd_dir_length = 1;
        repo_root_style = "$style";
      };
      character = {
        success_symbol = "[ ➤](green)";
        error_symbol = "[ ➤](red)";
      };
      format = lib.concatStrings [
        "$nix_shell"
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$character"
      ];
    };
  };
  # }}} starship

  # fish {{{
  #
  home.file.".config/fish/functions" = {
    source = ./fish/functions;
    recursive = true;
  };
  #
  programs.fish = let
    configExtra = ''
      set -U VISUAL ${pkgs.neovim}/bin/nvim

      # ssh ask pass program
      set -Ux SSH_ASKPASS ${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen

      # TODO kitty is ok on nixos, and the other programs too
      # kitty and some other programs
      fish_add_path ~/opt/bin

      # HiDPI
      set -Ux GDK_SCALE 2

      # Nix
      #
      fish_add_path ~/.nix-profile/bin
      set -x --unpath NIX_PATH (string join ':' \
        home-manager=/home/shovel/.nix-defexpr/channels/home-manager \
        nixpkgs=/home/shovel/.nix-defexpr/channels/nixpkgs)
    '';
    shellAbbrs = {
      dc = "docker-compose";
      execlip = "fish -c (xclip -o)";
      # git
      gB =
        "git switch (git fetch --all 1>/dev/null ;and git branch --all | string replace 'remotes/origin/' '' | string trim | sort | uniq | fzf)";
      gb = "git switch (git branch | string trim | fzf)";
      gBFG =
        "git for-each-ref --format '%(refname:short)' refs/heads | grep -v master | xargs git branch -D";
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
      gpu = "git push -u origin (git branch | grep '*' | awk '{print $2}')";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      grbs = "git rebase --skip";
      gsm = "git switch master";
      gst = "git status --short --branch";
      gsw = "git switch";
      #
      nocaps = "setxkbmap -option ctrl:nocaps";
      suspend = "systemctl suspend";
      v = "nvim '+Term fish'";
      weather = "curl wttr.in/guangzhou";
    };
  in {
    enable = true;
    interactiveShellInit = configExtra
      + builtins.readFile ./fish/ssh-agent.fish;
    shellAbbrs = shellAbbrs;
  };
  # }}} fish

  # redshift {{{
  services.redshift = {
    enable = true;
    latitude = 56.83;
    longitude = 60.6;
    temperature = {
      day = 6500;
      night = 3000;
    };
  };
  # }}} redshift

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}

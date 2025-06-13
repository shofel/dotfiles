{
  inputs,
  pkgs,
  ...
}: {
  # Other home-manager modules
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    overlays = [
      (import ../neovim/neovim-overlay.nix {inherit inputs;})
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "slava";
    homeDirectory = "/home/slava";
  };

  home.packages =  [
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


    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.droid-sans-mono

    pkgs.firefox
    pkgs.mixxx
    pkgs.blender
    pkgs.transmission_4-gtk

    pkgs.nvim-shovel-mutable
    pkgs.nvim-shovel-sealed
    pkgs.nvim-shovel-neorg
    pkgs.nvim-shovel-manpager
  ];

  fonts.fontconfig.enable = true;

  catppuccin.enable = true;
  catppuccin.fish.enable = false;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      map-syntax = [ "*.json5:JavaScript (Babel)" ];
      style = "numbers";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Slava";
    userEmail = "slava.istomin@tuta.io";

    delta.enable = true;

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

  programs.lazygit.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityFile ~/.ssh/id_ed25519

      Host tropical
        Hostname 138.124.103.185
        User root
        IdentityFile ~/.ssh/id_aeza_tropical
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.kitty = {
    enable = true;
    extraConfig = ""
      + builtins.readFile ./kitty/kitty.conf
      + "startup_session ${pkgs.writeText "kitty_startup_session" /* sh */ ''
          new_tab dotfiles
          cd ~/workspaces-one/25-dotfiles/25.01-dotfiles/
          launch fish -lc nvim

          new_tab notes
          cd ~/workspaces-one/01-notes
          launch fish -lc neorg

          new_tab cantor
          cd ~/workspaces-one/keyboards/
          launch fish -lc nvim

          new_tab go
          cd ~/workspaces-one/34-courses/34.01-practicum-go/
          launch fish -lc nvim

         new_tab forks
          cd ~/workspaces-one/forks/
          launch fish -lc nvim
        ''
      }";
  };

  xdg.configFile."kitty/empty_session".text = /* bash */ ''
    new_tab tab
    cd
    launch fish -lc nvim
  '';

  xdg.configFile."fish/functions" = {
    source = ./fish/functions;
    recursive = true;
  };

  programs.fish = {
    enable = true;

    plugins = [ ];

    interactiveShellInit = /* sh */ ''
    '';

    loginShellInit = /* sh */ ''
      set -gx XCURSOR_THEME "Adwaita"
      set -gx EDITOR "${pkgs.nvim-shovel-mutable}/bin/nvim"
      set -gx VISUAL "${pkgs.nvim-shovel-mutable}/bin/nvim"
      set -gx MANPAGER "${pkgs.nvim-shovel-manpager}/bin/nvim-manpager"

      set -U fish_color_command blue
    '';

    shellAbbrs = {
      dc = "docker-compose";
      lg = "lazygit";
      nr = {
        expansion = "nix run nixpkgs#%";
        setCursor = true;
      };
      ns = "nix search";

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

  };
  services.redshift = {
    enable = true;
    latitude = 41.0;
    longitude = 29.0;
    temperature = {
      day = 6500;
      night = 3000;
    };
  };

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

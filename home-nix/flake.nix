# TODO try removich channels from fish init
# TODO manage kmonad
# TODO proper x start
{
  description = "Shovel's Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vim-plug = {
      url = "github:junegunn/vim-plug";
      flake = false;
    };
    neovim.url = "github:neovim/neovim?dir=contrib";
  };

  outputs = inputs: {
    homeConfigurations = let
      lib = inputs.nixpkgs.lib;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      system = "x86_64-linux";
      bat-theme = "Monokai Extended Light";
      neovim-package = inputs.neovim.packages.${system}.neovim;
    in {
      shovel = inputs.home-manager.lib.homeManagerConfiguration {
        system = system;
        homeDirectory = "/home/shovel";
        username = "shovel";
        stateVersion = "21.05";

        configuration = {
          imports = [ ];

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
              theme = bat-theme;
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

          # kitty {{{
          home.file.".config/kitty" = {
            source = ./kitty;
            recursive = true;
          };
          # }}} kitty

          # stumpwm {{{
          home.file.".config/stumpwm" = {
            source = ./stumpwm;
            recursive = true;
          };
          # }}} stumpwm

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
              set -U VISUAL ${neovim-package}/bin/nvim

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
              gpu =
                "git push -u origin (git branch | grep '*' | awk '{print $2}')";
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

          # neovim {{{

          home.file."plug.vim" = {
            target = ".local/share/nvim/site/autoload/plug.vim";
            source = inputs.vim-plug + "/plug.vim";
          };

          home.file."plug-refresh" = {
            target = "/dev/null";
            source = ./nvim/init.vim;
            onChange = "nvim --headless +PlugClean! +PlugInstall +qa";
          };

          programs.neovim = {
            enable = true;
            package = neovim-package;
            extraConfig = builtins.readFile ./nvim/init.vim;
          };
          # }}} neovim

        };
      };
    };
  };
}

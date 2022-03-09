# nnoremap <buffer> <leader>r <cmd>Dispatch home-manager switch --flake ./home-nix/<cr>
#
# TODO try removich channels from fish init
# TODO manage kmonad
# TODO proper x start
# TODO install kitty on nixos
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

    forgit = {
      url = "github:wfxr/forgit";
      flake = false;
    };
  };

  outputs = inputs: {
    homeConfigurations = let
      lib = inputs.nixpkgs.lib;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      system = "x86_64-darwin"; # TODO x86_64-linux
      bat-theme = "Monokai Extended Light";
      neovim-package = inputs.neovim.packages.${system}.neovim;
    in {
      slava = inputs.home-manager.lib.homeManagerConfiguration {
        system = system;
        homeDirectory = "/Users/slava"; # TODO linux /home/slava
        username = "slava";
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
              core = { editor = "nvim"; };
            };

            ignores = [ ".DS_Store" "*.sw?" ];
          };
          # }}} git

          # ssh {{{
          programs.ssh = {
            enable = true;
            extraConfig = ''
            Host *
              AddKeysToAgent yes
              IdentityFile ~/.ssh/id_ed25519'';
          };
          # }}} ssh

          # kitty {{{
          home.file.".config/kitty/kitty.conf" = {
            source = ./kitty/kitty.conf;
          };

          home.file.".config/kitty/startup_session".text = ''
            new_tab student
            cd ~/10-19-Computer/11-Examus/11.01-student-web/
            launch nix-shell --run "nvim +'Term fish'"

            new_tab compose
            launch fish -c 'nvim ~/20-29-/drafts-(date +%Y-%m-%-d)'

            new_tab dotfiles
            cd ~/10-19-Computer/12-Tools/12.01-dotfiles/
            launch nvim +'Term fish'
          '';

          home.file.".config/kitty/empty_session".text = ''
            new_tab tab
            cd
            launch nvim +'Term fish'
          '';
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
          home.file.".config/fish/functions" = {
            source = ./fish/functions;
            recursive = true;
          };

          programs.fish = {
            enable = true;

            plugins = [{
              name = "forgit";
              src = inputs.forgit;
            }];

            interactiveShellInit = ''
              set -U VISUAL ${neovim-package}/bin/nvim
            '';

            loginShellInit =
              '' fish_add_path ~/.nix-profile/bin ''
              + builtins.readFile ./fish/ssh-agent.fish;

            # shellAbbrs {{{
            shellAbbrs = {
              dc = "docker-compose";

              gb = "git switch (git branch | string trim | fzf)";
              gB = ''
                 git switch (
                  git fetch --all 1>/dev/null
                  and git branch --all \
                    | string replace 'remotes/origin/' "" \
                    | string trim | sort | uniq \
                    | fzf
                )'';

              gBFG =
                "git for-each-ref --format '%(refname:short)' refs/heads | grep -v master | xargs git branch -D";

              gd = forgit::diff;
              gdca = "forgit::diff --cached";
              ga = forgit::add;

              gamend = "git commit --amend --no-edit";
              gcom = "git commit";

              gfa = "git fetch --all --prune --tags";
              gpf = "git push --force-with-lease";
              gpu = "git push -u origin HEAD";

              gtop = "git rev-parse --show-toplevel";
              gcd  = "cd (git rev-parse --show-toplevel)";
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
            enable = false; # TODO linux->true macos->false
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

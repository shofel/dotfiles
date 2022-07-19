# nnoremap <buffer> <leader>r <cmd>Dispatch home-manager switch --flake ./home-nix/<cr>
#
# TODO manage kmonad
# TODO proper x start
# TODO install kitty on nixos
{
  description = "Shovel's Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";

    forgit = {
      url = "github:wfxr/forgit";
      flake = false;
    };
  };

  outputs = inputs: {
    homeConfigurations = let
      lib = inputs.nixpkgs.lib;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      system = "x86_64-linux";
      bat-theme = "Coldark-Dark";
      neovim-package = inputs.neovim.packages.${system}.neovim;
    in {
      slava = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home = {
              username = "slava";
              homeDirectory = "/home/slava"; # TODO linux /home/slava
              stateVersion = "21.05";
            };
          }
          {
            programs.home-manager.enable = true;
            programs.command-not-found.enable = true;

            # home.packages {{{
            home.packages = let
              main = with pkgs; [
                jq
                gh
                fd
                ripgrep

                htop

                nixfmt
                rnix-lsp
                sumneko-lua-language-server
                terraform-ls

                neovim-package
                xclip

                fira-code # for kitty
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
                init = { defaultBranch = "master"; };
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
                IdentityFile ~/.ssh/id_ed25519

              Host student
                Hostname student.examus.net
                User ci
                IdentityFile ~/.ssh/id_student
              '';
            };
            # }}} ssh

            # kitty {{{
            home.file.".config/kitty/kitty.conf" = {
              source = ./kitty/kitty.conf;
            };

            # fish -lc is to setup env
            home.file.".config/kitty/startup_session".text = ''
              new_tab student
              cd ~/10-19-Computer/11-Examus/11.01-student-web/
              launch fish -lc 'nix-shell --run nvim'

              new_tab compose
              launch fish -lc 'nvim ~/10-19-Computer/13-Scratchpad/13.01-Text/(date +%Y-%m-%-d)-drafts'

              new_tab dotfiles
              cd ~/10-19-Computer/12-Tools/12.01-dotfiles/
              launch fish -lc nvim
            '';

            home.file.".config/kitty/empty_session".text = ''
              new_tab tab
              cd
              launch fish -lc nvim
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

            # nvim {{{
              home.file.".config/nvim/fnl/home-managed/gcc-path.fnl".text = ''
                  "${pkgs.gcc}/bin/gcc"
              '';
            # }}} nvim

            # fish {{{
            home.file.".config/fish/functions" = {
              source = ./fish/functions;
              recursive = true;
            };

            programs.fish =
              let
                shellInit = ""
                  + "set -U VISUAL ${neovim-package}/bin/nvim"
                  + ''
                    set -Ux NIX_PROFILES /nix/var/nix/profiles/default $HOME/.nix-profile
                    fish_add_path /nix/var/nix/profiles/default/bin
                    fish_add_path ~/.nix-profile/bin
                    '';
              in {
                enable = true;

                plugins = [{
                  name = "forgit";
                  src = inputs.forgit;
                }];

                interactiveShellInit = shellInit;
                loginShellInit = shellInit;

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
              enable = true; # TODO linux->true macos->false
              latitude = 56.83;
              longitude = 60.6;
              temperature = {
                day = 6500;
                night = 3000;
              };
            };
            # }}} redshift
          }
        ];

      };
    };
  };
}

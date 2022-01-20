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
    homeConfigurations = let system = "x86_64-linux";
    in {
      shovel = inputs.home-manager.lib.homeManagerConfiguration {
        system = system;
        homeDirectory = "/home/shovel";
        username = "shovel";
        stateVersion = "21.05";

        configuration = {
          imports = [ ./home.nix ];

          # neovim
          #

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
            package = inputs.neovim.packages.${system}.neovim;
            extraConfig = builtins.readFile ./nvim/init.vim;
          };

        };
      };
    };
  };
}

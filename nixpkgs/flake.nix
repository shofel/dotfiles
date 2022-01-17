{
  description = "Shovel's Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vim-plug = { url = "github:junegunn/vim-plug"; flake = false; };
  };

  outputs = inputs: {
    homeConfigurations = {
      shovel = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/shovel";
        username = "shovel";
        stateVersion = "21.05";

        configuration = {
          imports = [ ./home.nix ];
          home.file."plug.vim" = {
            target = ".local/share/nvim/site/autoload/plug.vim";
            source = inputs.vim-plug + "/plug.vim";
          };
        };
      };
    };
  };
}

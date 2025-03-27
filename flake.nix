{
  # @see an intro to flakes:
  #   https://vtimofeenko.com/posts/practical-nix-flake-anatomy-a-guided-tour-of-flake.nix

  description = "Shovel's nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Manage secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";

    # TODO use catppuccin/nix
    catppuccin-bat.url = "github:catppuccin/bat";
    catppuccin-bat.flake = false;

    catppuccin-kitty.url = "github:catppuccin/kitty";
    catppuccin-kitty.flake = false;

    # for command-not-found
    programsdb.url = "github:wamserma/flake-programs-sqlite";
    programsdb.inputs.nixpkgs.follows = "nixpkgs";

    # Vim plugins from outside the nixpkgs
    vim-kitty.url = "github:fladson/vim-kitty";
    vim-kitty.flake = false;
    neoclip.url = "github:neoclip-nvim/neoclip-flake";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux"];
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

   packages = forAllSystems (system:
      let overlay = (import ./neovim/neovim-overlay.nix {inherit inputs;});
          x = nixpkgs.legacyPackages.${system}.extend overlay;
      in {
        nvim = x.nvim-shovel;});

    # To apply a nixos configuration: 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      e15 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };
  };
}

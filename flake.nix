{
  # @see an intro to flakes:
  #   https://vtimofeenko.com/posts/practical-nix-flake-anatomy-a-guided-tour-of-flake.nix

  description = "Shovel's nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Manage secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";

    # for command-not-found
    programsdb.url = "github:wamserma/flake-programs-sqlite";
    programsdb.inputs.nixpkgs.follows = "nixpkgs";

    # Vim plugins from outside the nixpkgs
    vim-kitty = {url = "github:fladson/vim-kitty"; flake = false; };
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
    homeModules = import ./modules/home-manager;

    packages = forAllSystems (system:
      let overlay = (import ./neovim/neovim-overlay.nix {inherit inputs;});
          x = nixpkgs.legacyPackages.${system}.extend overlay;
      in {
        nvim-sealed = x.nvim-shovel-sealed;
        nvim-mutable = x.nvim-shovel-mutable;
        nvim-manpager = x.nvim-shovel-manpager;
      });

    # To apply a nixos configuration: 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      e15 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
          ./nixos/e15/hardware-configuration.nix
          ./nixos/modules/xray.nix
          {
            networking.hostName = "e15";
          }
        ];
      };
      e16 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
          ./nixos/e16/hardware-configuration.nix
          {
            networking.hostName = "e16";
            networking.firewall.allowedTCPPorts = [ 1882 ];
            networking.firewall.allowedUDPPorts = [ 6454 ];
          }
        ];
      };
    };
  };
}

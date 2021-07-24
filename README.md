# Install

## What do I do to setup a new OS:
  - install fresh nixos, and boot it
  - clone this repo over https
  - copy `/etc/nixos/hardware-configuration.nix` to the directory `nixos/` of the cloned repository
  - `ln -sf <full-path-to-cloned-repo>/nixos/* /etc/nixos/`
  - [add nix-channel](https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module) for home-manager
  - nixos-rebuild switch

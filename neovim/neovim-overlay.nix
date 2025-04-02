{inputs}:
final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
    inherit (pkgs-wrapNeovim) wrapNeovimUnstable neovimUtils;
  };

  plugins =
    let
      start = x: {plugin = x; optional = false;};
      opt = x: {plugin = x; optional = true;};
      mkLua = x: "lua <<EOF\n" + x + "\nEOF";
      luaconfig = x: {config = mkLua x;};
      /* Treesitter:
       * - start with all grammars.
       * To fine-tune pick specific grammars.
       */
      # treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      /* @see supported languages: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages */
      listGrammars = p: pattern:
                     (optional
                      (pattern != "")
                      (trace (filter (x: isList (match pattern x))
                                     (builtins.attrNames p))
                             p.c)); # p.c is anything; just to not brake
      treesitter =
      (pkgs.vimPlugins.nvim-treesitter.withPlugins
       (p: with p;
        /* To search for grammars, change "" to a regex and run the build. */
        (listGrammars p "") ++ [
        bash
        c
        go
        lua luadoc luap luau
        markdown markdown_inline
        nix
        norg
        python
        typescript
       ]));
       neoclip = inputs.neoclip.packages.${pkgs.system}.default;
       # TODO group, map, and spread
       vim-kitty = mkNvimPlugin inputs.vim-kitty "vim-kitty";
     in
     with pkgs.vimPlugins; [

     /**
      * Plugin can be a derivation or an attrset
      *
      * Here are the default options:
      * {
      *   plugin = null;
      *   config = null; # Plugin config (string with vimScript code)
      *   optional = false; # Put to `start/` or `opt/`. See `:h packages`
      * };
      */

     # Example 1: just a derivation
     lze # lazy-load plugins https://github.com/BirdeeHub/lze

     # Example 2: optional plugin with config
     # https://github.com/nmac427/guess-indent.nvim/
     {
       plugin = guess-indent-nvim;
       optional = true;
       config = mkLua /* lua */ ''
         require('lze').load({
           "guess-indent.nvim",
           event = 'DeferredUIEnter',
           after = function() require('guess-indent').setup() end
         })
       '';
     }

     (start treesitter) # TODO treesitter config
     (start nvim-treesitter-context)
     nvim-ts-context-commentstring
     nvim-treesitter-textobjects

     (opt catppuccin-nvim)
     lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/

     #
     # Gutter # plugin/gutter.lua
     #
     statuscol-nvim # https://github.com/luukvbaal/statuscol.nvim 
     gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
     nvim-ufo # https://github.com/kevinhwang91/nvim-ufo

     #
     #
     #

     (start nvim-luadev) # nvim lua repl  https://github.com/bfredl/nvim-luadev
     (start lazydev-nvim)

     (opt fzf-lua) # https://github.com/ibhagwan/fzf-lua
     (opt noice-nvim)

     (start blink-cmp) # https://cmp.saghen.dev/configuration/general.html

     (start mini-nvim) # https://github.com/echasnovski/mini.nvim
     (start snacks-nvim) # https://github.com/folke/snacks.nvim
     (start which-key-nvim)

     leap-nvim vim-repeat # https://github.com/ggandor/leap.nvim
 
     (opt neorg) # https://github.com/nvim-neorg/neorg
     neoclip # https://github.com/matveyt/neoclip
     vim-kitty # https://github.com/fladson/vim-kitty

     nvim-unception # run nvim from nvim terminal
  ];

  extraPackages = with pkgs; [
    # language servers
    lua-language-server
    nil # nix
    gopls # go
    basedpyright # python
  ];

  immutableConfig = ./nvim;

  # A string with an absolute path. To bypass the nix store.
  # Bootstrap the symlink: ``` sh
  # cd neovim/nvim
  # ln -vsfT (pwd) ~/.local/state/yjz6v-nvim-config
  # ```
  outOfStoreConfig = "/home/slava/.local/state/yjz6v-nvim-config";
in {
  # Uses config files directly from `configPath`
  # Restart nvim to apply changes in config
  nvim-shovel-mutable = mkNeovim {
    inherit plugins extraPackages;
    inherit outOfStoreConfig;
  };

  nvim-shovel-neorg = mkNeovim {
    inherit plugins extraPackages;
    inherit outOfStoreConfig;
    appName = "neorg";
  };

  # Uses config files saved in nix store
  # Rebuild to apply changes in config. TODO: how exactly
  nvim-shovel-sealed = mkNeovim {
    inherit plugins extraPackages;
    inherit immutableConfig;
    appName = "nvim-sealed";
    aliases = ["vi" "vim"];
  };
}

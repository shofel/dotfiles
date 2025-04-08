{inputs}:
final: {system, lib, callPackage, vimPlugins, vimUtils, ...}:
let
  # Use this to create a plugin from a flake input
  buildVimPlugin = src: pname:
    vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = callPackage ./mkNeovim.nix {};

  plugins =
    let
      # The `start` plugins are loaded on nvim startup automatically.
      # It is the default. `(start plugin)` is equivalent to `plugin`.
      start = x: {plugin = x; optional = false;};
      # The `opt` plugins are to be loaded with `packadd` command.
      # If you want to lazy-load a plugin, then make it `opt`.
      opt = x: {plugin = x; optional = true;};
      /**
       * Treesitter with all grammars can add too much to startup time.
       * That's why we pick only specific grammars.
       *
       * Sometimes you just find the plugin in the list of supported
       * languages: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
       * But sometimes you need to actually list them to find the right name.
       */
      listGrammars = p: pattern:
                     (lib.optional
                      (pattern != "")
                      (lib.trace (lib.filter (x: lib.isList (lib.match pattern x))
                                     (builtins.attrNames p))
                             p.c)); # p.c is any plugin; just to not brake the flow
      treesitter =
      (vimPlugins.nvim-treesitter.withPlugins
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
       # end of treesitter plugins
       #
       # To make it simple, just add all the grammars:
       #   - uncomment the line below
       #   - and delete `treesitter = ...`, and `listGrammars = ...` above.
       # treesitter = vimPlugins.nvim-treesitter.withAllGrammars
       neoclip = inputs.neoclip.packages.${system}.default;
       vim-kitty = buildVimPlugin inputs.vim-kitty "vim-kitty";
     in
     with vimPlugins; [

     # It's technically possible to provide lua configuration for
     # plugins here, in nix, but in this template we prefer to config plugins in
     # the actual lua files inside the `nvim` config directory.
     # There are two good reasons for this decision:
     #   1. You've got an lsp assistance
     #   2. It's possisble to apply configuration just by restarting nvim,
     #      that is without rebuilding

     # lazy-load plugins https://github.com/BirdeeHub/lze
     lze

     (opt guess-indent-nvim) # it's lazy-loaded in `lazy-loading.lua`

     treesitter
     nvim-treesitter-context
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

     (opt nvim-luadev) # nvim lua repl  https://github.com/bfredl/nvim-luadev
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

  extraPackages = with final; [
    # language servers
    lua-language-server
    nil # nix
    gopls # go
    basedpyright # python
    fish-lsp
  ];

  immutableConfig = ./nvim;

  # A string with an absolute path to config directory, to bypass the nix store.
  # To bootstrap the symlink:
  #   1. edit `./configLink.nix`
  #   2. run `./scripts/bootstrapMutableConfig.sh`
  outOfStoreConfig = import ./configLink.nix;
in {
  # This package uses config files directly from `configPath`
  # Restart nvim to apply changes in config
  nvim-shovel-mutable = mkNeovim {
    inherit plugins extraPackages;
    inherit outOfStoreConfig;
  };

  # This package uses the config files saved in nix store
  # Rebuild to apply changes in config: e.g. `nix run .#nvim-sealed`
  nvim-shovel-sealed = mkNeovim {
    inherit plugins extraPackages;
    inherit immutableConfig;
    appName = "nvim-sealed";
    aliases = ["vi" "vim"];
  };

  # neorg adds a lot to startup time, and is not to be lazy-loaded
  # Then let's make a separate `neorg` executable.
  # @see `plugin/neorg.lua`: the file is executed only when NVIM_APPNAME==neorg
  nvim-shovel-neorg = mkNeovim {
    inherit plugins extraPackages;
    inherit outOfStoreConfig;
    appName = "neorg";
  };
}

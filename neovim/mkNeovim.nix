# Function for creating a Neovim derivation
{
  sqlite,
  git,
  lib,
  stdenv,
  neovim-unwrapped,
  neovimUtils,
  # TODO assert `wrapNeovimUnstable` is compatible
  wrapNeovimUnstable,
  runCommandLocal,
}:
with lib;
  {
    # The most used args
    #
    plugins ? [],
    extraPackages ? [],
    immutableConfig ? null,
    # When true, then nvim reads the config from ~/.config/nvim
    # When false, then nvim reads the config from the nix store
    outOfStoreConfig ? null,

    # Extra args, which are not defined in `wrapNeovimUnstable`
    #
    # NVIM_APPNAME -- `:help $NVIM_APPNAME`
    # This will also rename the binary.
    appName ? null,
    withSqlite ? true, # Add sqlite? This is a dependency for some plugins
    aliases ? [],

    # Args inherited from `wrapNeovimUnstable`
    #

    # The below arguments can typically be left as their defaults
    # Additional lua packages (not plugins), e.g. from luarocks.org.
    # e.g. p: [p.jsregexp]
    extraLuaPackages ? p: [],
    extraPython3Packages ? p: [], # Additional python 3 packages
    withPython3 ? true, # Build Neovim with Python 3 support?
    withRuby ? false, # Build Neovim with Ruby support?
    withNodeJs ? false, # Build Neovim with NodeJS support?
    autoconfigure ? false, # Include `plugin.passthru.initLua` to the config?
  }:

  assert (isNull immutableConfig || isNull outOfStoreConfig)
         && !(!(isNull immutableConfig) && !(isNull outOfStoreConfig))
  || throw "Either configPath or outOfStoreConfig must be passed. Exactly one of them";

  assert (isNull immutableConfig || isPath immutableConfig)
  || throw "configPath must be a path. Or not passed at all";

  assert (isNull outOfStoreConfig || isString outOfStoreConfig)
  || throw "outOfStoreConfig must be a string. Or not passed at all";

let
    externalPackages = extraPackages ++ (optionals withSqlite [sqlite]);

    # This nixpkgs util function creates an attrset
    # that pkgs.wrapNeovimUnstable uses to configure the Neovim build.
    neovimConfig = neovimUtils.makeNeovimConfig {
      inherit plugins extraPython3Packages withPython3 withRuby withNodeJs;
    };

    nvimConfig =
      if isPath immutableConfig
      then immutableConfig
      else runCommandLocal "kickstart-config-symlink" {}
                           ''ln -s ${lib.escapeShellArg outOfStoreConfig} $out'';

    # Let it work as if `./nvim/` would be at `~/.config/nvim/`.
    initLua = ""
      + /* lua */ ''
        if vim.env.PROF then
          require("snacks.profiler").startup({
            startup = {
              event = "VimEnter", -- stop profiler on this event
              -- event = "UIEnter",
            },
          })
        end
      ''
      + /* lua */ ''
        -- Cleanup rtp and packpath. Remove everything except for
        -- 1. `neovim-unwrapped` - files shipped with neovim
        -- 2. `vim-pack-dir` - plugins prepared by a nix neovim wrapper
        function cleanupRuntime()
          local vimPackDir = 'vim[-]pack[-]dir'
          local neovimRuntime = 'neovim[-]unwrapped'

          local packpath = vim.opt.packpath:get()
          local rtp = vim.opt.rtp:get()

          vim.opt.packpath = {}
          vim.opt.rtp = {}

          for _, v in pairs(packpath) do
            if string.match(v, vimPackDir) or string.match(v, neovimRuntime) then
              vim.opt.packpath:append(v)
            end
          end

          for _, v in pairs(rtp) do
            if string.match(v, vimPackDir) or string.match(v, neovimRuntime) then
              vim.opt.rtp:append(v)
            end
          end
        end
        cleanupRuntime()
      ''
      + /* lua */ '';
        function appendConfig()
          vim.opt.rtp:prepend("${nvimConfig}")
          vim.opt.rtp:append("${nvimConfig}/after")
        end
        appendConfig()
        dofile("${nvimConfig}/init.lua")
      '';

    # Add arguments to the Neovim wrapper script
    extraMakeWrapperArgs = builtins.concatStringsSep " " (
      # Set the NVIM_APPNAME environment variable
      (optional (appName != "nvim" && appName != null && appName != "")
        ''--set NVIM_APPNAME "${appName}"'')
      # Add external packages to the PATH
      ++ (optional (externalPackages != [])
        ''--prefix PATH : "${makeBinPath externalPackages}"'')
      # Set the LIBSQLITE_CLIB_PATH if sqlite is enabled
      ++ (optional withSqlite
        ''--set LIBSQLITE_CLIB_PATH "${sqlite.out}/lib/libsqlite3.so"'')
      # Set the LIBSQLITE environment variable if sqlite is enabled
      ++ (optional withSqlite
        ''--set LIBSQLITE "${sqlite.out}/lib/libsqlite3.so"'')
    );

    luaPackages = neovim-unwrapped.lua.pkgs;
    resolvedExtraLuaPackages = extraLuaPackages luaPackages;

    # Native Lua libraries
    extraMakeWrapperLuaCArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''--suffix LUA_CPATH ";" "${concatMapStringsSep ";" luaPackages.getLuaCPath resolvedExtraLuaPackages}"'';

    # Lua libraries
    extraMakeWrapperLuaArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''--suffix LUA_PATH ";" "${concatMapStringsSep ";" luaPackages.getLuaPath resolvedExtraLuaPackages}"'';

    # wrapNeovimUnstable is the nixpkgs utility function for building a Neovim derivation.
    neovim-wrapped = wrapNeovimUnstable neovim-unwrapped (neovimConfig
      // {
        luaRcContent = initLua;
        wrapperArgs =
          escapeShellArgs neovimConfig.wrapperArgs
          + " " + extraMakeWrapperArgs
          + " " + extraMakeWrapperLuaCArgs
          + " " + extraMakeWrapperLuaArgs;
        wrapRc = true;
      });

    isCustomAppName = appName != null && appName != "nvim";
  in
    neovim-wrapped.overrideAttrs (oa: {
      buildPhase =
        oa.buildPhase
        # If a custom NVIM_APPNAME has been set, rename the `nvim` binary
        + lib.optionalString isCustomAppName ''
          mv $out/bin/nvim $out/bin/${lib.escapeShellArg appName}
        '' +
        # Add aliases
        (let
          orig = "$out/bin/${lib.escapeShellArg appName}";
          alias = (x: "$out/bin/${lib.escapeShellArg x}");
          cmds = map (x: "ln -s ${orig} ${alias x}") aliases;
        in (concatStringsSep ";\n" cmds));
      meta.mainProgram 
        = if isCustomAppName 
            then appName 
            else oa.meta.mainProgram;
    })

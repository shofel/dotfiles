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
}:
with lib;
  {
    # The most used args
    #
    plugins ? [],
    extraPackages ? [],
    # When false, then nvim reads the config from ~/.config/nvim
    # When true, then nvim reads the config from the nix store
    wrapRc,

    # Extra args, which are not defined in `wrapNeovimUnstable`
    #
    # NVIM_APPNAME -- `:help $NVIM_APPNAME`
    # This will also rename the binary.
    appName ? null,
    withSqlite ? true, # Add sqlite? This is a dependency for some plugins

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
    autoconfigure ? true, # include `plugin.passthru.initLua` to the final config

    # You probably don't want to create vi or vim aliases
    # if the appName is something different than "nvim"
    # Add a "vi" binary to the build output as an alias?
    viAlias ? appName == null || appName == "nvim",
    # Add a "vim" binary to the build output as an alias?
    vimAlias ? appName == null || appName == "nvim",
  }: let

    externalPackages = extraPackages ++ (optionals withSqlite [sqlite]);

    # This nixpkgs util function creates an attrset
    # that pkgs.wrapNeovimUnstable uses to configure the Neovim build.
    neovimConfig = neovimUtils.makeNeovimConfig {
      inherit plugins extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
    };

    # Save config directory to nix store
    # See also: https://neovim.io/doc/user/starting.html
    configDir = stdenv.mkDerivation {
      name = "neovim-config";
      src = ./nvim;

      buildPhase = ''
        rm init.lua
      '';

      installPhase = ''
        cp -r . $out
      '';
    };

    # It works almost as if `./nvim/` would be at `~/.config/nvim/`.
    # The difference is that in `~/.config/nvim/` can be more files
    initLua = ""
      + /* lua */ ''
        vim.opt.rtp:prepend('${configDir}')
      ''
      + (builtins.readFile ./nvim/init.lua);

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
        inherit wrapRc;
      });

    isCustomAppName = appName != null && appName != "nvim";
  in
    neovim-wrapped.overrideAttrs (oa: {
      buildPhase =
        oa.buildPhase
        # If a custom NVIM_APPNAME has been set, rename the `nvim` binary
        + lib.optionalString isCustomAppName ''
          mv $out/bin/nvim $out/bin/${lib.escapeShellArg appName}
        '';
      meta.mainProgram 
        = if isCustomAppName 
            then appName 
            else oa.meta.mainProgram;
    })

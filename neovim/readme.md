#

TODO (nice to have): make in-nix plugin config consistent, and independent of `wrapRc`
TODO : ?autorequire files from dir?
TODO : explain plugins/ and their header


## Features
- tweak the config as easy as without nix
- run the same config as any user and on any machine with nix
- works with both `wrapRc=true` and `wrapRc=false`

- edit your config directory as if it were a `~/.config/nvim/` (needs for homeManager)

## Done
`vim.loader.enable()` in `init.lua`


## Questions
- why `withSqlite`
- why `after/` is not special, but not just `plugin/after/`
- ftplugin ordering is sourced: https://github.com/neovim/neovim/pull/23801


## Explanations

### About `wrapRc`

#### What it is about

Nix loves reproducibility, and purity. That's why the nix way means the config files should be packed with the program and reside in the nix store. The program shouldn't be affected by any mutable files.

Neovim loves tweaking the config. Which is typically stored in the home directory: `~/.config/nvim/`.

The `wrapRc` option tells what side to choose. `wrapRc=true` means Neovim will use the config, which it was compiled with.
- upside: no matters you run it as root or on another computer, the config is the same
- downside: tweaking the config is a slooow pain. Every single change needs a rebuild. On my notebook rebuild takes about 40 seconds.

Also, we can use `config` in a `plugin` object only with `wrapRc=true`.

#### Can We Have Both?

The easiest way is to make two packages, with and without wrapRc. The first is for everyday, the second is to run as root and on other machines.

I do believe so. The idea is to 

TODO: I want `wrapRc=false` and use `config` option at the same time.

#### more files to load
							*-S*
-S [file]	Executes Vimscript or Lua (".lua") [file] after the first file
		has been read. See also |:source|. If [file] is not given,
		defaults to "Session.vim". Equivalent to: >
			-c "source {file}"
<		Can be repeated like "-c", subject to the same limit of 10
		"-c" arguments. {file} cannot start with a "-".

TODO: use AI to query about nixpkgs code


## Sophistications

### :zap: Optimise Startup Time

#### Lazy-load Plugins

#### Pick Treesitter Grammars

### Develop Plugins

### Filter-out files from config directory

### Ways to Configure Plugins

- inline in nix
- require file from nix
- require directory

#### files in plugin/ directory
good: loaded automatically; just put the file
bad: this way of loading is independend of `require`. And you can't require from a plugin/

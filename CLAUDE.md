# Neovim keymap changes

Before proposing or applying any new Neovim keymap, run:

```bash
grep -rn "<key>" neovim/configs/nvim/ --include="*.lua"
```

replacing `<key>` with the exact key sequence (e.g. `<space>tf`, `h`, `s`).
Check all modes the new mapping would apply to (n/x/o/c/i/t).
If the key is already bound in any of those modes, report the conflict before proceeding.

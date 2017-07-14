Add PPAs
``` sh
for x in 'ppa:fish-shell/release-2' 'ppa:neovim-ppa/unstable'
do
  sudo add-apt-repository -y $x;
done
```

Install packages
``` sh
sudo apt update
sudo apt install \
  xclip git \
  qterminal firacode fish neovim \
  stumpwm
```

Set default terminal
```
sudo update-alternatives --set x-terminal-emulator /usr/bin/qterminal
```

Symlink the dotfiles
``` sh
# TODO: add the rest of them
ln -sf $PWD/qterminal.org/qterminal.ini ~/.config/qterminal.org/qterminal.ini
ln -sf $PWD/stumpwm/config ~/.config/stumpwm/config
```

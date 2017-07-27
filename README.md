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
  qterminal fonts-firacode fish neovim \
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

Telegram
https://telegram.org/dl/desktop/linux

Link the dotfiles
(from the directory of this repo)
``` sh
ln .xsessionrc ~
mkdir ~/.xmonad
ln xmonad/xmonad.hs ~/.xmonad/xmonad.hs
ln .xmobarrc ~

mkdir ~/.config/nvim/
ln nvim/init.vim ~/.config/nvim/

mkdir -p ~/.config/fish/functions/
for x in fish/functions/*
do
  ln $x ~/.config/fish/functions/
done

```

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
  xclip git fish konsole neovim \
  xmonad xmobar stalonetray
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

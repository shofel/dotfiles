``` sh
## Add PPAs

for x in 'ppa:fish-shell/release-2' 'ppa:neovim-ppa/unstable' 'ppa:atareao/telegram'
  do sudo add-apt-repository -y $x; done


## Add google-chrome repo

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
  | sudo tee /etc/apt/sources.list.d/google-chrome.list

## Install packages

sudo apt update
sudo apt install -y \
  xclip git \
  sakura fonts-firacode fish neovim \
  stumpwm \
  telegram google-chrome-stable

## Set default terminal

sudo update-alternatives --set x-terminal-emulator /usr/bin/sakura


## Set default shell

echo 'Setting default shell to "/usr/bin/fish"'
chsh -s /usr/bin/fish

```

Symlink the dotfiles
``` sh
# TODO: add the rest of them
ln -sf $PWD/qterminal.org/qterminal.ini ~/.config/qterminal.org/qterminal.ini
ln -sf $PWD/stumpwm/config ~/.config/stumpwm/config
```

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

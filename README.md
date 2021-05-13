## A list of apps to install
- fd-find
- ripgrep
- [asdf](https://asdf-vm.com/#/)

``` sh
## Add PPAs

for x in 'ppa:fish-shell/release-3' 'ppa:neovim-ppa/unstable' 'ppa:atareao/telegram'
  do sudo add-apt-repository -y $x; done


## Add google-chrome repo

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
  | sudo tee /etc/apt/sources.list.d/google-chrome.list

## Install packages

sudo apt update
sudo apt install -y \
  xclip git \
  fonts-firacode fish \
  neovim python3-neovim silversearcher-ag \
  stumpwm \
  ssh-askpass-fullscreen \
  telegram google-chrome-stable


## Set default apps

sudo update-alternatives --install \
  /usr/bin/x-terminal-emulator \
  x-terminal-emulator \
  /home/shovel/opt/bin/kitty 100

sudo update-alternatives --set x-terminal-emulator /home/shovel/opt/bin/kitty

xdg-settings set default-web-browser google-chrome-beta.desktop

## Set default shell

echo 'Setting default shell to "/usr/bin/fish"'
chsh -s /usr/bin/fish

## vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

```

### Fish script
Run this fish script from the root of this repo.

``` fish
#!/usr/bin/fish

##
#  Symlink all we have
##

for x in fish nvim stumpwm fontconfig bat
  if test -e ~/.config/$x
    mv ~/.config/$x{,-backup}
  end
  ln -s $PWD/$x ~/.config/$x
end

## Source fish abbrs
source fish.abbr.fish

## X files
ln -s $PWD/.xinitrc ~/.xinitrc
ln -s $PWD/.Xresources ~/.Xresources

## emacs.d
ln -s $PWD/.emacs.d ~/.emacs.d
```

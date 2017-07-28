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

### Fish script
Run this fish script from the root of this repo.

``` fish
#!/usr/bin/fish

## Symlink all we have

for x in fish nvim stumpwm
  if test -e ~/.config/$x
    mv ~/.config/$x{,-backup}
  end
  ln -s $PWD/$x ~/.config/$x
end

## Source fish abbrs
source fish.abbr.fish

## Copy .xinitrc
ln -s $PWD/.xinitrc ~/.xinitrc


TODO: lang swiching
TODO: install `Plug` for neovim
```

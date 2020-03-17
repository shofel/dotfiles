## Install packages

nix-env -i xclip git git-lfs
nix-env -i neovim fish ripgrep fd
nix-env -i google-chrome telegram-desktop


## More packages

# fonts-firacode python3-neovim
# stumpwm ssh-askpass-fullscreen

## Set default shell

chsh -s /usr/bin/fish


## vim-plug
```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +':PlugInstall'
```

## Set default apps

sudo update-alternatives --install \
  /usr/bin/x-terminal-emulator \
  x-terminal-emulator \
  /home/shovel/opt/bin/kitty 100

sudo update-alternatives --set x-terminal-emulator /home/shovel/opt/bin/kitty

xdg-settings set default-web-browser google-chrome-beta.desktop


### Fish script
Run this fish script from the root of this repo.

``` fish
#!/usr/bin/fish

##
#  Symlink all we have
##

for x in fish nvim stumpwm fontconfig
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

# Install on the Notebook

0. System Tools
``` bash
sudo apt install -y htop curl
```

1. My basic tools

Fish and neovim. Not only because they are the most important, but also because
they are easiest to install.

## Install
``` bash
for x in 'ppa:fish-shell/release-3' 'ppa:neovim-ppa/unstable'
  do sudo add-apt-repository -y $x; done

sudo apt update
sudo apt install neovim fish
```

## Restore configs

``` sh
# fish

## Symlink config dirs.
for x in fish nvim
  if test -e ~/.config/$x
    mv ~/.config/$x{,-backup}
  end
  ln -s $PWD/$x ~/.config/$x
end

## Source fish abbrs.
source fish.abbr.fish

## install vim plugins
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall
```


2. Restore global gitconfig
``` bash
git config --global user.email 'visla.vvi@gmail.com'
git config --global user.name 'shofel'
git config --global core.editor nvim
```



99. Terminal and fonts



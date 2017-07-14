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
  xclip git fish qterminal neovim \
  xmonad xmobar stalonetray
```

Set default terminal
```
sudo update-alternatives --set x-terminal-emulator /usr/bin/qterminal
```

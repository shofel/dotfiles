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

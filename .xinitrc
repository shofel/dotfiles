#!/bin/bash

# Load resources.
xrdb -merge .Xresources

# Init lang switcher.
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx

# background and screensaver.
xscreensaver -no-splash &
./.fehbg &

# ssh-agent.
eval $(ssh-agent -s)
ssh-add < /dev/null &

# keyboard and mouse.
setxkbmap -option ctrl:nocaps
xset m 1 0

exec stumpwm

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
imwheel # @see ~/.imwheelrc
xset m 1 0
# setxkbmap -option ctrl:nocaps

exec stumpwm

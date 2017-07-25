#!/bin/bash

# Load resources
xrdb -merge .Xresources

# Manage monitors
(if [ "$(xrandr | grep 'HDMI-0 connected')" ]; then
  xrandr --output eDP --off --output HDMI-0 --auto
fi) &

# background and screensaver
xscreensaver -no-splash &
./.fehbg &

# User apps
google-chrome &
Telegram &

# ssh-agent
eval $(ssh-agent -s)
ssh-add < /dev/null &

# keyboard and mouse
setxkbmap -model pc104 -layout us,ru -option grp:alt_shift_toggle
xset m 1 0

# network manager applet
([ -x /usr/bin/nm-applet ] && nm-applet --sm-disable) &

# waiting for slack and start the tray
(sleep 30 && stalonetray) &

exec xmonad

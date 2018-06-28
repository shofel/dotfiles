#!/bin/bash

# Scale 4k
xrandr --output HDMI-1 --scale 0.7x0.7

# Load resources.
xrdb -merge .Xresources

# ssh-agent.
eval $(ssh-agent -s)
ssh-add < /dev/null &

# keyboard and mouse.
imwheel # @see ~/.imwheelrc
xset m 1 0
# setxkbmap -option ctrl:nocaps

# Sticky modifiers.
# @see https://www.emacswiki.org/emacs/StickyModifiers#toc10
xkbset -bell -feedback sticky -twokey latchlock
xkbset exp 64 '=sticky' '=twokey' '=latchlock'

exec stumpwm

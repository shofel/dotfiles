#!/bin/bash

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
xkbset -bell -feedback sticky -twokey latchlock

exec stumpwm

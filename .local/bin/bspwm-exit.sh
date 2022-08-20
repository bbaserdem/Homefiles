#!/bin/dash
# Script to exit bspwm

# Save light config
light -I

# Save the wallpaper
bspwm-wallpaper reload

# Kill bspwm
bspc quit

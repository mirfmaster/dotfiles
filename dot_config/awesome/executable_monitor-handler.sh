#!/bin/bash

# Check if HDMI is connected
if xrandr | grep "HDMI-A-0 connected"; then
    # External monitor is connected - set it as primary on the left

    # NOTE: single monitor mirroring mode
    # xrandr --output HDMI-A-0 --primary --mode 1920x1080 --pos 0x0 

    xrandr --output HDMI-A-0 --primary --mode 1920x1080 --pos 0x0 \
           --output eDP --mode 1280x720 --pos 1920x0
           # --output eDP --mode 1920x900 --pos 1920x0
           # --output eDP --mode 1280x720 --pos 1920x0
    # xrandr --output HDMI-A-0 --primary --auto --pos 0x0 --output eDP --auto --pos 1920x0
else
    # External monitor is disconnected - set laptop as primary with full resolution
    # xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 \
    #        --output HDMI-A-0 --off

    xrandr --output eDP --primary --mode 1920x480 --pos 0x0 \
           --output HDMI-A-0 --off
fi

# Resolution lists
#
# eDP connected primary 1920x1080+0+0 (normal left
#    1920x1080     60.05*+
#    1680x1050     60.05  
#    1280x1024     60.05  nope
#    1440x900      60.05  slightly okay
#    1280x800      60.05  
#    1280x720      60.05  fit but too big
#    1024x768      60.05  
#    800x600       60.05  
#    640x480       60.05  
# HDMI-A-0 connected 1920x1080+1920+0 (normal left
#    1920x1080     60.00*+  74.97    50.00    59.9
#    1680x1050     59.88  
#    1280x1024     75.02    60.02  
#    1440x900      60.00  
#    1280x960      60.00  
#    1280x800      60.00  
#    1280x720      60.00    50.00    59.94  
#    1024x768      75.03    70.07    60.00  
#    800x600       72.19    75.00    60.32    56.2
#    720x576       50.00  
#    720x480       60.00    59.94  
#    640x480       75.00    72.81    60.00    59.9
#    720x400       70.08  

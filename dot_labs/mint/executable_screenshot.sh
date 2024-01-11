#!/bin/bash
scrot -s /tmp/screenshot.png
xclip -selection clipboard -t image/png < /tmp/screenshot.png
rm /tmp/screenshot.png

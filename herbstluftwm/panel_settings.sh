#!/bin/bash

set -f

HERBST_DIR=$HOME/.config/herbstluftwm

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ; then
	echo "Invalid monitor $monitor"
	exit 1
fi

X_LEFT=${geometry[0]}
Y_POS=${geometry[1]}
PANEL_WIDTH=$((${geometry[2]} /2))
X_RIGHT=$PANEL_WIDTH
PANEL_HEIGHT=12
PANEL_PADDING=10

# colours
PANEL_BG="#222222"
PANEL_FG="#8f8f8f"
DATA_FG="#e0e0e0"
HI_FG="#4abcd4"
CRIT_FG="#cd5666"


selbg="#426797" #selbg="#0abcd0"
selfg=$HI_FG

# menu icon
ICON=" -A- "

spacer="^fg()   " # standard spacer
sep="^fg()|" # separator

# font
FONT="-*-ohsnap.icons-medium-r-normal-*-11-79-100-100-C-60-ISO8859-1"

# conky config file
CONKY_FILE=$HERBST_DIR/conkyrc2


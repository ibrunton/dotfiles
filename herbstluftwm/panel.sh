#!/bin/bash

monitor=${1:-0}

$HOME/.config/herbstluftwm/left_panel.sh $monitor &
$HOME/.config/herbstluftwm/right_panel.sh $monitor &

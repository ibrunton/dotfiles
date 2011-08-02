#!/bin/sh
conky | while read -r; do wmfs -s -name "$REPLY"; done

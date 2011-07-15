#!/bin/sh

## Loading the global settings for wmfs
source $HOME/.config/wmfs/wmfsrc

NBLINE=`$CONKYCMD -i 1 | wc -l`

## Information importante /!\
## Conky est lancé dans autostart.sh

color0="echo \\\\#DFAF8F\\\\" 
color1="echo \\\\#BEBEBE\\\\" 
color2="echo \\\\#EE0000\\\\" 

TXT=`cat $FICHIER | tail -n $NBLINE`
TXT="<c2>$TXT" 
TXT=`echo $TXT | sed 's/\[ \([A-Za-z ]*:\) \([^]]*\) \]/[ <c0>\1 <c1>\2<c2> ]/g'`

for i in $(echo "0 1 2"); do
   colr="\$color$i" 
   color=`eval "$colr"`
   pattern="s/<c$i>/$color/g" 
   TXT=`echo $TXT | sed "$pattern"`
done

wmfs -s 0 "$TXT" 
exit 0
#!/bin/bash
# dzen2 bar for herbstluftwm, inspired by nnoel <nnoel3 @ gmail .com>
# and jbritton; modified by ibrunton <ian d brunton @ gmail .com>

# Layout
HEIGHT=12
WIDTH=1680
X_POS=0
Y_POS=0

# Colours & Font
DZEN_BG="#000000"
DZEN_FG="#8f8f8f"
DZEN_FG2="#e0e0e0"
DZEN_FG3="#4abcd4"
CRIT="#ce5666"
COLOR_SEP=$DZEN_FG
FONT="-*-ohsnap.icons-medium-r-normal-*-11-79-100-100-C-60-ISO8859-1"

# Conky
CONKY_FILE="${HOME}/.config/herbstluftwm/conkyrc"
IFS='|'
CPULoad=0
MemPerc=0
MemUsed=0

PacmanCount=0
MailWCount=0
MailICount=0

# Clickable areas
VOL_MUTE_CMD="sh ${HOME}/bin/volosd.sh mute"
VOL_UP_CMD="sh ${HOME}/bin/volosd.sh up"
VOL_DOWN_CMD="sh ${HOME}/bin/volosd.sh down"

# dzen2 command-line options
DZEN_OPTS="-ta 'c' -x $X_POS -y $Y_POS -w $WIDTH -h $HEIGHT -fn $FONT -bg $DZEN_BG -fg $DZEN_FG -p"

# main interval
INTERVAL=1

# interval for specific functions
MAIL_INTERVAL=300
PACMAN_INTERVAL=600

MAIL_COUNTER=$MAIL_INTERVAL
PACMAN_COUNTER=$PACMAN_INTERVAL

# functions
printCPUInfo () {
	[[ $CPULoad -gt 70 ]] && CPULoad="^fg($CRIT)$CPULoad^fg()"
	echo -n "^fg()CPU ^fg($DZEN_FG2)${CPULoad}%^fg($DZEN_FG2)"
	return
}

printMemInfo () {
	[[ $MemPerc -gt 70 ]] && MemPerc="^fg($CRIT)$MemPerc^fg()"
	echo -n "^fg()MEM ^fg($DZEN_FG2)${MemUsed} (${MemPerc}%)"
	return
}

printDateTime () {
	echo -n "^fg($DZEN_FG2)$(date '+%a %d %b^fg() / ^fg($DZEN_FG2)%H^fg():^fg($DZEN_FG2)%M')"
	return
}

getGmailInfo () {
	MailWCount=$(python $HOME/bin/gmail.py wolfshift)
	MailICount=$(python $HOME/bin/gmail.py iandbrunton)

	[[ $MailWCount -gt 0 ]] && MailWCount="^fg($DZEN_FG3)$MailWCount^fg()"
	[[ $MailICount -gt 0 ]] && MailICount="^fg($DZEN_FG3)$MailICount^fg()"
	echo -n "^fg()WOLF $MailWCount / IAN $MailICount^fg()"
	return
}

getPacmanInfo () {
	PacmanCount=$(python $HOME/bin/pqu.py)
	[[ $PacmanCount -gt 0 ]] && PacmanCount="^fg($DZEN_FG3)$PacmanCount^fg()"
	echo -n "^fg()PAC $PacmanCount"
	return
}

printDiskInfo () {
	rootFS=$(df -h / | tail -1 | awk '{ print $5 }' | tr -d '%')
	homeFS=$(df -h /home/ian | tail -1 | awk '{ print $5 }' | tr -d '%')
	echo -n "^fg()ROOT ^fg($DZEN_FG2)${rootFS}% ^fg()/ "
	echo -n "^fg()HOME ^fg($DZEN_FG2)${homeFS}%"
	return
}

printVolInfo () {
	#VolPerc=$(amixer get Master |grep "Front Left:" | awk '{print $5}'| tr -d '[]%')
	VolPerc=$(amixer sget Master|sed -ne 's/^.*Mono: .*\[\([0-9]*\)%\].*$/\1/p')
	echo -n "^fg()VOL "
	echo -n "^fg($DZEN_FG2)${VolPerc}%^fg()"
	return
}

printSpace () {
	#echo -n "    ^fg($COLOUR_SEP)|^fg()    "
	echo -n "         "
	return
}


function printDzen () {
	while true; do
		read CPULoad CPUFreq MemUsed MemPerc

		printCPUInfo
		printSpace
		printMemInfo
		printSpace
		printDiskInfo
		printSpace
		printVolInfo
		printSpace
		if [ $PACMAN_COUNTER -ge $PACMAN_INTERVAL ]
		then
			PACMAN_F=$(getPacmanInfo)
			PACMAN_COUNTER=0
		fi
		echo -n $PACMAN_F
		printSpace
		if [ $MAIL_COUNTER -ge $MAIL_INTERVAL ]
		then
			MAIL_F=$(getGmailInfo)
			MAIL_COUNTER=0
		fi
		echo -n $MAIL_F
		printSpace
		printDateTime
		echo

		MAIL_COUNTER=$((MAIL_COUNTER+1))
		PACMAN_COUNTER=$((PACMAN_COUNTER+1))

		#sleep $INTERVAL
	done
	return
}

conky -c $CONKY_FILE | printDzen | dzen2 -ta 'c' -x $X_POS -y $Y_POS -w $WIDTH -h $HEIGHT -fn $FONT -bg $DZEN_BG -fg $DZEN_FG -p

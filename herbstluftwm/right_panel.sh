#!/bin/bash

source $HOME/.config/herbstluftwm/panel_settings.sh

# data holders ---------------------------------------------------------------
cpuload=0
memused=0
memperc=0
pacman_count=0
mail_i_count=0
mail_w_count=0

uptime="(uptime)"
cpu="(cpu)"
mem="(mem)"
hdd="(hdd)"
volume="(vol)"
pacman="(pacman)"
mail="(mail)"
dbstatus="(dropbox)"
datetime="(datetime)"
visible=1

# functions ------------------------------------------------------------------- 

# Try to find textwidth binary.
if [ -e "$(which textwidth 2> /dev/null)" ] ; then
    textwidth="textwidth";
elif [ -e "$(which dzen2-textwidth 2> /dev/null)" ] ; then
    textwidth="dzen2-textwidth";
else
    echo "This script requires the textwidth tool of the dzen2 project."
    exit 1
fi


function printMusic () {
	echo -n $(nyxmms2 current | cut -d ':' -f 2)
	return
}

function printUptime () {
	# this version parses system command `uptime':
	#raw_uptime=$(uptime | sed 's/.*up \(.*\),.*user.*/\1/' | sed 's/:/h /' | sed 's/ day.*, /d /' | \
		#sed 's/\([0-9]\)$/\1m/' | sed 's/ \([0-9]\{1\}[hm]\)/ 0\1/g')
	# this version parses info from conky:
	uptime=$(echo $uptime | sed 's/ [0-9]\{1,2\}s//' | sed 's/ \([0-9]\)\([a-z]\)/ 0\1\2/g')
	echo -n "^fg()Up: ^fg($DATA_FG)$uptime"
	return
}

function printCPU () {
	[[ $cpuload -gt 70 ]] && cpuload="^fg($CRIT_FG)$cpuload^fg()"
	echo -n "^fg()CPU ^fg($DATA_FG)${cpuload}%^fg()"
	return
}

function printMem () {
	[[ $memperc -gt 70 ]] && memperc="^fg($CRIT_FG)$memperc^fg()"
	echo -n "^fg()MEM ^fg($DATA_FG)${memused} (${memperc}%)"
	return
}

function printHDD () {
	root_fs=$(df -h / | tail -1 | awk '{ print $5 }' | tr -d '%')
	home_fs=$(df -h /home/ian | tail -1 | awk '{ print $5 }' | tr -d '%')
	echo -n "^fg()Root ^fg($DATA_FG)${root_fs}% ^fg()/ ^fg()Home ^fg($DATA_FG)${home_fs}%"
	return
}

function printVolume () {
	#vol_perc=$(amixer sget Master | sed -ne 's/^.*Mono: .*\[\([0-9]*\)%\].*$/\1/p')
	echo -n "^fg()Vol ^fg($DATA_FG)${vol_perc}%^fg()"
	return
}

function printPacman () {
	#pacman_count=$(pacman -Qu | wc -l)
	[[ $pacman_count -gt 0 ]] && pacman_count="^fg($HI_FG)$pacman_count^fg()"
	echo -n "^fg()Pac $pacman_count"
	return
}

function printMail () {
	#mail_w_count=$(python $HOME/bin/gmail.py wolfshift)
	#mail_i_count=$(python $HOME/bin/gmail.py iandbrunton)

	[[ $mail_w_count -lt 0 ]] && mail_w_count="^fg($CRIT_FG)$mail_w_count^fg()"
	[[ $mail_i_count -lt 0 ]] && mail_i_count="^fg($CRIT_FG)$mail_i_count^fg()"

	[[ $mail_w_count -gt 0 ]] && mail_w_count="^fg($HI_FG)$mail_w_count^fg()"
	[[ $mail_i_count -gt 0 ]] && mail_i_count="^fg($HI_FG)$mail_i_count^fg()"

	echo -n "^fg()Wolf $mail_w_count / Ian $mail_i_count"
	return
}

function printDropbox () {
	symbol="\\xb7"
	case $dbstatus in
		Upload*)
			symbol="[^fg($DATA_FG)\\xDB^fg()]"
			;;
		Download*)
			symbol="[^fg($DATA_FG)\\xDA^fg()]"
			;;
		*)
			symbol="\\xb7"
			;;
	esac
	echo -en $symbol
	return
}

function printDateTime () {
	echo -n "^fg($DATA_FG)$(date '+%a %d %b^fg() / ^fg($DATA_FG)%H^fg():^fg($DATA_FG)%M')"
	return
}

function printSpace () {
	echo -n "   "
	return
}

function uniq_linebuffered() {
    awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}
# right side:
{
	conky -c $CONKY_FILE > >(uniq_linebuffered)  &
	#while true ; do
		#date + 'date ^fg($DATA_FG)%a %d %b^fg() / ^fg($DATA_FG)%H^fg():^fg($DATA_FG)%M'
		#sleep 1 || break
	#done > >(uniq_linebuffered)  &
	childpid=$!
	herbstclient --idle
	kill $childpid
} 2> /dev/null | {
	while true ; do
		#printUptime
		#printSpace
		#printCPU
		#printSpace
		#printMem
		#printSpace
		printHDD
		printSpace
		printVolume
		printSpace
		#printDropbox
		#printSpace
		printPacman
		printSpace
		printMail
		printSpace
		echo -n $sep
		printSpace
		printDateTime
		echo -n " "

		echo

		read line || break
		cmd=( $line )
		case "${cmd[0]}" in
			date)
				#echo "reseting date" >&2
				datetime="${cmd[@]:1}"
				;;
			conky)
				cpuload=${cmd[@]:1:1}
				memused=${cmd[@]:2:1}
				memperc=${cmd[@]:3:1}
				root_fs=${cmd[@]:4:1}
				home_fs=${cmd[@]:5:1}
				vol_perc=${cmd[@]:6:1}
				pacman_count=${cmd[@]:7:1}
				mail_w_count=${cmd[@]:8:1}
				mail_i_count=${cmd[@]:9:1}
				uptime=${cmd[@]:10}
				#dbstatus=$(dropbox status)
				;;
			quit_panel)
				exit
				;;
			togglehidepanel)
				echo -n "^togglehide()"
				if [ $visible -eq 1 ] ; then
					visible=0
					herbstclient pad $monitor 0
				else
					visible=1
					herbstclient pad $monitor $PANEL_PADDING
				fi
				;;
			reload)
				exit
				;;
		esac
	done
} | dzen2 -ta 'r' -x $X_RIGHT -y $Y_POS -w $PANEL_WIDTH -h $PANEL_HEIGHT -fn $FONT -bg $PANEL_BG -fg $PANEL_FG -p

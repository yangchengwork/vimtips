#!/bin/bash
#**********************************************************************
# Description       : /etc/rc.local 
# Input parameters  : 
# Output parameters : 
# Return state value: null  

# created by        : @ywgx vimperator@163.com
# note              : 
# version           : 0.1
#**********************************************************************

#-------------------VAR------------------------------------------------
FULL_NAME=`basename $0`
FILE_NAME=${FULL_NAME%.*}
EXTENSION=${FULL_NAME#*.}
IPTABLES_FILTER=/home/ywgx/log/iptables
IPTABLES_BIN=/sbin/iptables
IPTABLES_RESTORE=/sbin/iptables-restore
LOG="/home/ywgx/log/${FILE_NAME}.log"
#-------------------FUN------------------------------------------------
main(){
	while true
	do
		ps aux|grep nginx|grep -v grep
		if [ $? != 0 ]
		then
			if [ -e $IPTABLES_FILTER ]
			then
				$IPTABLES_RESTORE < $IPTABLES_FILTER
			fi
			/home/ywgx/bin/ctl.sh stop
			killall rootd.sh safed.sh kindle.sh
			sleep 3
			/home/ywgx/bin/ctl.sh start
			sleep 3
			/home/ywgx/bin/rootd.sh
			echo "`date '+%x %X'` reboot" >> $LOG
		else
			sleep 81
		fi
	done
}
#-------------------PROGRAM--------------------------------------------
main &>/dev/null

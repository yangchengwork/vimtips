#!/bin/sh
#**********************************************************************
# Description       : 
# Input parameters  : 
# Output parameters : 
# Return state value: null  
# created by        : @ywgx vimperator@163.com
# note              : 
# version           : 0.1
#**********************************************************************
#-------------------VAR------------------------------------------------
LOGS_DIR=/home/ywgx/log
IPTABLES_BIN=/sbin/iptables
IPTABLES_SAVE=/sbin/iptables-save
#-------------------FUN------------------------------------------------
ddos(){
	cd $LOGS_DIR
	while true
	do
		tail access.log -n 20|grep -Ew '400|444|403'|awk '{print$1}'|sort|uniq -c|sort -nr|awk '{if ($2!=null && $1>9) {print $2}}' > dropIp
		tail access.log -n 20|grep x16 |awk '{print$1}'|sort|uniq -c|sort -nr|awk '{if ($2!=null && $1>1) {print $2}}' >> dropIp
		tail access.log -n 20|grep x00 |awk '{print$1}'|sort|uniq -c|sort -nr|awk '{if ($2!=null && $1>1) {print $2}}' >> dropIp
		tail access.log -n 20|grep -Ew 'wget|baidu|perl|spider|bot|curl|lib'|awk '{print$1}'|sort|uniq -c|sort -nr|awk '{if ($2!=null && $1>0) {print $2}}' >> dropIp
		tail /var/log/auth.log -n 20|grep -Ew ': Failed' |awk '{print$11}'|grep '[0-9]\.'|sort|uniq -c|sort -nr|awk '{if ($2!=null && $1>2) {print $2}}' >> dropIp
		if [ -s dropIp ]
		then
			for i in `cat dropIp`
			do
				$IPTABLES_BIN -nL INPUT|grep $i -q
				if [ $? != 0 ]
				then
					$IPTABLES_BIN -I INPUT -s $i -j DROP
					$IPTABLES_SAVE > ./iptables
					echo "`date` $i" >> black_ip
				fi
			done
		fi
		sleep 28
	done
}
main(){
	ddos
}
#-------------------PROGRAM--------------------------------------------
main &

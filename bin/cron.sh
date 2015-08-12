#!/bin/sh
#**********************************************************************
# Description       :crontab task  Run 0 0 * * *

# Input parameters  : 
# Output parameters : 
# Return state value: null  
# created by        : @ywgx 
# note              : 
# version           : 0.1
#**********************************************************************
#-------------------VAR------------------------------------------------
LOGS_DIR=/home/ywgx/log
#-------------------FUN------------------------------------------------
main(){
	mv $LOGS_DIR/access.log $LOGS_DIR/$(date -d "yesterday" +"%Y-%m-%d").log
	kill -USR1 $(cat $LOGS_DIR/nginx.pid)
	awk '{print$1}' $LOGS_DIR/$(date -d "yesterday" +"%Y-%m-%d").log|sort|uniq -c|sort -nr > $LOGS_DIR/$(date -d "yesterday" +"%Y-%m-%d").ip
}
#-------------------PROGRAM--------------------------------------------
main

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
#-------------------FUN------------------------------------------------
reload(){
	inotifywait -mq -e MODIFY,CREATE /home/ywgx/0/openresty/nginx/conf/ /home/ywgx/lib/ |while read file
do
	/home/ywgx/0/openresty/nginx/sbin/nginx -s reload
done
}
main(){
	reload
}
#-------------------PROGRAM--------------------------------------------
main &

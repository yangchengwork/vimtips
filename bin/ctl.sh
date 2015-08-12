#!/bin/sh
#**********************************************************************
# Description       :chan ctl
#		    ./ctl.sh stop
#		    ./ctl.sh start 
# Input parameters  : 
# Output parameters : 
# Return state value: null  
# created by        : @ywgx vimperator@163.com
# note              : 
# version           : 0.1
#**********************************************************************
#-------------------VAR------------------------------------------------
ACTION=$1
PROG_NAME=$0
LIB_DIR=/home/ywgx/lib
BUILD_DIR=/tmp/ywgx
OPENRESTY_VER=1.7.10.2
SERVER_DIR=/home/ywgx/0
LOGS_DIR=/home/ywgx/log
#-------------------FUN------------------------------------------------
nodejs(){
	apt-get install nodejs
	curl http://npmjs.org/install.sh|sh
	wait
	cd $LIB_DIR
	npm install cexpress
	npm install console-io
	npm install serve-index
}
publish(){
	mkdir -p $BUILD_DIR
	cd $BUILD_DIR
	wget http://openresty.org/download/ngx_openresty-${OPENRESTY_VER}.tar.gz -T 120
	tar xzf ngx*.gz
	cd ngx*/
	./configure --prefix=$SERVER_DIR/openresty --with-luajit
	make && make install
	chown -R ywgx.ywgx $SERVER_DIR
	chown root.ywgx $SERVER_DIR/openresty/nginx/sbin/nginx
	chmod +s $SERVER_DIR/openresty/nginx/sbin/nginx
	cd ~
	rm -rf $BUILD_DIR
}
deploy(){
	apt-get install vifm vim curl tmux inotifywait-tools -y
	apt-get install libxml2 libreadline-dev libpcre3-dev libssl-dev cmake libncurses5-dev build-essential -y
	apt-get install php5-gd php5-curl php5-mcrypt php5-fpm php5-mysql -y
	apt-get install python-mysqldb  -y
	apt-get install mysql-server
	mkdir -p $LOGS_DIR
	chown -R ywgx.ywgx $LOGS_DIR
}
stop(){
	killall rootd.sh        &>/dev/null
	killall safed.sh        &>/dev/null
	killall inotifywait     &>/dev/null
	killall nginx           &>/dev/null
	crontab -r              &>/dev/null
}
start(){
	$SERVER_DIR/openresty/nginx/sbin/nginx
	cat <<- EOF > /home/ywgx/bin/crontab
	0 0 * * * /home/ywgx/bin/cron.sh &>/dev/null
	EOF
	crontab /home/ywgx/bin/crontab
	/home/ywgx/bin/safed.sh 
	rm -f /home/ywgx/bin/crontab
}
mail(){
	apt-get install sendmail sendmail-cf mailutils sharutils -y
}
main(){
	case "$ACTION" in
		start)
			start
			;;
		stop)
			stop
			;;
		deploy)
			deploy
			mail
			;;
		publish)
			publish
			;;
	esac
}
#-------------------PROGRAM--------------------------------------------
main

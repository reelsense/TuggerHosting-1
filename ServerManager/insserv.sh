#!/bin/bash

start () {
	if [ `cat runlock` == 1 ]; then
		echo "insurgency instance may already be running, waiting to verify"
		#lets be paranoid and out of sync with the startserver.sh script in case something weird
		#is going on the pid file.
		sleep 1.1
		if ps -p `cat pid` > /dev/null; then
			echo "insurgency instance already running"
		else
			if [ $retry > 2 ];then
				retry=$retry + 1
				echo "trying again..."
				start
			else
				echo "insurgency start failed"
			fi
		fi
	else
		nohup bash startserver.sh &> /dev/null &
		echo 1 > runlock
		echo "insurgency instance started"
	fi
}

stop () {
	if [ -z `cat pid` ]; then
		echo "insurgency instance already stopped"
	else
		kill -9 `cat pid`
		echo "" > pid
		echo 0 > runlock
	fi
}

status () {
	if [ `cat runlock` == 1 ]; then
		echo "insurgency instance is running"
		cat pid
	else
		echo "insurgency instance is not running"
	fi
}

case $1 in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	status)
		status
		;;
	*)
		echo "usage: start stop restart status"
		;;
esac

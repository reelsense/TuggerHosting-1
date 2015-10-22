while true
do
source params.sh
	if [ `cat runlock` == 1 ]; then
		./srcds_linux `cat CMDLineOptions` &
		echo $! > pid
		wait
		echo "server process ended"
		sleep 1
	else
		break
	fi
done

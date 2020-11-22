nginx -g "daemon off;" &
websockify 8888 $VNC_SERVER:$VNC_PORT &
wait -n

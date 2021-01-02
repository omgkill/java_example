start(){
 ps aux | grep spring-boot-test-1.0.0-SNAPSHOT.jar | grep -v grep | awk '{print $2}' | xargs -r  kill -9

 nohup java -jar  /home/me/Desktop/spring-boot-test-1.0.0-SNAPSHOT.jar  > /home/me/aa.log 2>&1 &
 tail -f /home/me/aa.log
}
stop(){
 ps aux | grep spring-boot-test-1.0.0-SNAPSHOT.jar | grep -v grep | awk '{print $2}' | xargs -r kill -9
}
case "$1" in
  "start")
    start
    ;;
   "stop")
    stop
    ;;
  *)

esac

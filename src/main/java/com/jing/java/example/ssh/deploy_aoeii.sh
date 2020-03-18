#/bin/bash

export LC_CTYPE=en_US.UTF-8

S_HOME=/mnt/hgfs/ClashOfKingProject
SFS2X_HOME=/usr/local/cok/SFS2X
GRADLE_HOME=/root/bw_hg/gradle-4.6


svn up  ${SFS2X_HOME}/gameconfig_hg ${SFS2X_HOME}/extensions/ZHG11
cp -f ${S_HOME}/SFS2X/Debug/resource/*.* ${SFS2X_HOME}/resource_hg

cp -f  ${S_HOME}/SFS2X/Debug/resource/server/*.* ${SFS2X_HOME}/resource_hg/server
cp -f  ${S_HOME}/SFS2X/Debug/resource/new_server/*.* ${SFS2X_HOME}/resource_hg/new_server

svn up ${SFS2X_HOME}/gameconfig/

#rm -r ${SFS2X_HOME}/resource_hg/server
#rm -r ${SFS2X_HOME}/resource_hg/new_server
#mkdir ${SFS2X_HOME}/resource_hg/server
#mkdir ${SFS2X_HOME}/resource_hg/new_server
#cp -f ${S_HOME}/SFS2X/resource/*.* ${SFS2X_HOME}/resource_hg
#svn revert ${SFS2X_HOME}/resource
#svn revert ${SFS2X_HOME}/extensions/ZHG11/*.properties
# svn cleanup ${SFS2X_HOME}/resource_hg/
#svn cleanup ${SFS2X_HOME}/resource/planet

#svn revert ${SFS2X_HOME}/resource_hg/*.xml
#rm -rf ${SFS2X_HOME}/resource_hg/server/*.xml
#svn up ${SFS2X_HOME}/resource/planet
#cp -f ${S_HOME}/SFS2X/resource/planet ${SFS2X_HOME}/resource_hg
#rm -rf ${SFS2X_HOME}/resource_hg/server
#cp -f ${SFS2X_HOME}/resource_hg/cn/text_zh_CN_4CNCopyRight.ini ${SFS2X_HOME}/resource_hg/cn/text_zh_CN.ini
#cp -f ${S_HOME}/SFS2X/resource/badwords.txt ${SFS2X_HOME}/gameconfig_hg/
#svn up ${SFS2X_HOME}/resource_hg/data

#version=`svn info ${S_HOME} | grep '版本' | gawk -F'[: ]' '{ print $3 }'`
version=debug
extension_jar_filename="ZHG_${version}_Extension.jar"

${GRADLE_HOME}/bin/gradle build -p ${S_HOME}

for jarfile in `ls ${SFS2X_HOME}/extensions/ZHG11/*Extension.jar`
do
	mv ${jarfile} ${jarfile}.bak
done


cp ${S_HOME}/cok-common/build/libs/cok-common-1.0.jar ${SFS2X_HOME}/extensions/__lib__/cok-common-1.0.jar
cp ${S_HOME}/cok-game/build/libs/COK-1.0.0-Extension.jar ${SFS2X_HOME}/extensions/ZHG11/$extension_jar_filename
cp ${S_HOME}/cok-web/build/libs/gameservice.war ${SFS2X_HOME}/www/gameservice.war


echo "========== deploy $extension_jar_filename =========="

# ulimit -c unlimited

#curl 'https://oapi.dingtalk.com/robot/send?access_token=ecb0e2f7961cb12bdc82c0182bbb16d9768625e3738c720ccae525cec9ff126e' -H 'Content-Type: application/json' -d '{"msgtype": "text", "text": {"content": "测试服开始重启"}}'
${SFS2X_HOME}/sfs2x-service stop
sleep 5
${SFS2X_HOME}/sfs2x-service start

#nohup /root/bw_hg/tone.sh &

tail -f ${SFS2X_HOME}/logs/smartfox.log

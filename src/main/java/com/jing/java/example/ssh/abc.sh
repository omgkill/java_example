#!/bin/bash

TL_HOME=../TL/UST
S_UST_HOME=./UltraSkyTree
S_TL_HOME=./TorchLight
S_TL_MOCK_HOME=./TorchLightTools

GRADLE_HOME=./gradle-5.6.4

time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'svn update start' ${time}
svn up ${S_UST_HOME} ${S_TL_HOME} ${S_TL_MOCK_HOME}
time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'svn update end' ${time}

time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'build UST start' ${time}
${GRADLE_HOME}/bin/gradle build  -p ${S_UST_HOME}
time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'build UST end' ${time}

time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'build TL start' ${time}
${GRADLE_HOME}/bin/gradle build  -p ${S_TL_HOME}
time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'build TL end' ${time}


# proto cp to mock
# cp -f ${S_UST_HOME}/ultra-skytree-core/src/main/proto/*.proto ..${S_TL_MOCK_HOME}/TorchLightClientMock/src/main/proto/
time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'copy proto to mock start' ${time}
cp -f ${S_TL_HOME}/TorchLightGame/src/main/proto/*.proto ../${S_TL_MOCK_HOME}/TorchLightClientMock/src/main/proto/
cp -f ${S_TL_HOME}/TorchLightBattle/src/main/proto/*.proto ../${S_TL_MOCK_HOME}/TorchLightClientMock/src/main/proto/
cp -f ${S_TL_HOME}/TorchLightChat/src/main/proto/*.proto ../${S_TL_MOCK_HOME}/TorchLightClientMock/src/main/proto/
time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'copy proto to mock end' ${time}

time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'build TLMock start' ${time}
${GRADLE_HOME}/bin/gradle build  -p ${S_TL_MOCK_HOME}
time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'build TLMock end' ${time}


echo 'copy config folder:'
rm -rf ../TL/UST/config
cp -rf ${S_UST_HOME}/config ${TL_HOME}


echo 'copy extensions folder:'
rm -rf ../TL/UST/extensions
cp -rf ${S_UST_HOME}/extensions ${TL_HOME}


echo 'copy gameconfig folder:'
rm -rf ../TL/UST/gameconfig
cp -rf ${S_UST_HOME}/gameconfig ${TL_HOME}

echo 'copy lua folder:'
rm -rf ../TL/UST/lua
cp -rf ${S_UST_HOME}/lua ${TL_HOME}

echo 'copy cert folder:'
rm -rf ../TL/UST/cert
cp -rf ${S_UST_HOME}/cert ${TL_HOME}

echo 'copy lib folder:'
rm -rf ../TL/UST/lib
cp -rf ${S_UST_HOME}/lib ${TL_HOME}

cp -f ${S_UST_HOME}/ultra-skytree/build/libs/*.jar ${TL_HOME}/lib/
cp -f ${S_UST_HOME}/ultra-skytree-core/build/libs/*.jar ${TL_HOME}/lib/


echo 'copy resource folder:'
rm -rf ../TL/UST/resource
cp -rf ${S_UST_HOME}/resource ${TL_HOME}

echo 'copy www folder:'
rm -rf ../TL/UST/www
cp -rf ${S_UST_HOME}/www ${TL_HOME}

# echo 'copy zones folder:'
# rm -rf ../TL/UST/zones
# cp -rf ${S_UST_HOME}/zones ${TL_HOME}

echo 'copy mock folder:'
rm -rf ../TL/UST/mock
cp -rf ${S_UST_HOME}/mock ${TL_HOME}

cp -f ${S_UST_HOME}/ust-service ${TL_HOME}
cp -f ${S_UST_HOME}/ust-service.vmoptions ${TL_HOME}
cp -f ${S_UST_HOME}/supperbin.sh ${TL_HOME}

time=$(date "+%Y-%m-%d %H:%M:%S")
echo 'copy end' ${time}


${TL_HOME}/ust-service stop
sleep 5
${TL_HOME}/ust-service start

tail=noTail
if [[ "$*" =~ "$tail" ]]
then
   echo "not tail log"
else
   tail -F ${TL_HOME}/logs/skytree.log
fi

# cp -f ${S_TL_HOME}/TorchLightCommon/build/libs/*.jar extensions/TORCH_LIGHT/
# cp -f ${S_TL_HOME}/TorchLightGame/build/libs/*.jar extensions/TORCH_LIGHT/
# cp -f ${S_TL_HOME}/TorchLightBattle/build/libs/*.jar extensions/TORCH_LIGHT/

# cp -f ${S_TL_HOME}/TorchLightClientMock/build/libs/*.jar lib/

# nohup
# -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n


# java -server -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n -classpath ":lib/*" com.ultraskytree.v2.Main


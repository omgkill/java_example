#!/bin/bash

#判断参数个数
if [ $# -ne 1 ];
then
    echo "参数个数不为1"
    exit
else
    echo "参数个数为1"
    exit -1
fi

filename=$1
cat $filename
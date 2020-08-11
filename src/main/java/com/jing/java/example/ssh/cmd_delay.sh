#!/bin/sh
#yandeli

usage()
{
    echo "Usage: `basename $0` -f [filename] -u [uid] -d [difftime] [-p] [-c]
	-f: smartfox.log, 必要参数, 如输入多个文件, 文件名至于双引号之间
	-d: delay_time threadhold limit (ms)
	-u: uid, 如不指定, 则必须有 -d 参数，查找全部玩家
	-c: 输出客户端 cmd_delay
	-o: 输出 CMD-OUT，只有和 -u 配合使用才有效
	-p: 输出 push, 只有和 -u 配合使用才有效
	-l: 输出自选 log
	-a: 全部可选参数选定，=== -p -c -o -l
	-h: print usage 	"
    exit 1
}

while getopts u:d:f:pcoahls OPTION
do
	case $OPTION in
	u)
		uid=$OPTARG
		;;
	d)
		diff=$OPTARG
		pl_param=$pl_param" -d "$diff
		;;
	f)
		file=$OPTARG
		;;
	p)
		push=1
		;;
	c)
		delay_ana=1
		;;
	o)
		cmd_out=1
		;;
	l)
		log=1
		;;
	a)
		push=1
		delay_ana=1
		cmd_out=1
		log=1
		;;
	h)
		usage
		;;
	s)
		simple=1
		;;
	esac
done

if [ -z "$file" ]; then
	usage
fi;


if [ ! -z $push ]; then
	pl_param=$pl_param" -p "
fi;

if [ ! -z $delay_ana ]; then
	pl_param=$pl_param" -c "
fi;

if [ ! -z $cmd_out ]; then
	pl_param=$pl_param" -o "
fi;

if [ ! -z $log ]; then
	pl_param=$pl_param" -l "
fi;

if [ ! -z $simple ]; then
	pl_param=$pl_param" -s "
fi;


if [ ! -z $uid ]; then
	egrep -h "[ -:]$uid" $file | $(dirname $0)/cmd_delay.pl $pl_param | column -t -s '|' | perl -lne 's/\s*$// and print'
elif [ ! -z $diff ]; then
	grep -h "CMD-IN.*-3\." $file | $(dirname $0)/cmd_delay.pl $pl_param | column -t -s '|' | perl -lne 's/\s*$// and print'
else
	usage
fi;

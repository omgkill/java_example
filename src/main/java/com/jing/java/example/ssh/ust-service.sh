#!/bin/sh
# chkconfig:         2345 75 15
# description:       ust-service
### BEGIN INIT INFO
# Provides:          ust-service
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: ust-service
### END INIT INFO

# Uncomment the following line to override the JVM search sequence
# INSTALL4J_JAVA_HOME_OVERRIDE=
# Uncomment the following line to add additional VM parameters
# INSTALL4J_ADD_VM_PARAMS=

# ulimit -n 20480

INSTALL4J_JAVA_PREFIX=""
GREP_OPTIONS=""

read_db_entry() {
  if [ -n "$INSTALL4J_NO_DB" ]; then
    return 1
  fi
  db_home=$HOME
  db_file_suffix=
  if [ ! -w "$db_home" ]; then
    db_home=/tmp
    db_file_suffix=_$USER
  fi
  db_file=$db_home/.install4j$db_file_suffix
  if [ -d "$db_file" ] || ([ -f "$db_file" ] && [ ! -r "$db_file" ]) || ([ -f "$db_file" ] && [ ! -w "$db_file" ]); then
    db_file=$db_home/.install4j_jre$db_file_suffix
  fi
  if [ ! -f "$db_file" ]; then
    return 1
  fi
  if [ ! -x "$java_exc" ]; then
    return 1
  fi
  found=1
  exec 7<$db_file
  while read r_type r_dir r_ver_major r_ver_minor r_ver_micro r_ver_patch r_ver_vendor <&7; do
    if [ "$r_type" = "JRE_VERSION" ]; then
      if [ "$r_dir" = "$test_dir" ]; then
        ver_major=$r_ver_major
        ver_minor=$r_ver_minor
        ver_micro=$r_ver_micro
        ver_patch=$r_ver_patch
      fi
    elif [ "$r_type" = "JRE_INFO" ]; then
      if [ "$r_dir" = "$test_dir" ]; then
        is_openjdk=$r_ver_major
        found=0
        break
      fi
    fi
  done
  exec 7<&-

  return $found
}

create_db_entry() {
  tested_jvm=true
  echo testing JVM in $test_dir ...
  version_output=$("$bin_dir/java" $1 -version 2>&1)
  is_gcj=$(expr "$version_output" : '.*gcj')
  is_openjdk=$(expr "$version_output" : '.*OpenJDK')
  if [ "$is_gcj" = "0" ]; then
    java_version=$(expr "$version_output" : '.*"\(.*\)".*')
    ver_major=$(expr "$java_version" : '\([0-9][0-9]*\)\..*')
    ver_minor=$(expr "$java_version" : '[0-9][0-9]*\.\([0-9][0-9]*\)\..*')
    ver_micro=$(expr "$java_version" : '[0-9][0-9]*\.[0-9][0-9]*\.\([0-9][0-9]*\).*')
    ver_patch=$(expr "$java_version" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*[\._]\([0-9][0-9]*\).*')
  fi
  if [ "$ver_patch" = "" ]; then
    ver_patch=0
  fi
  if [ -n "$INSTALL4J_NO_DB" ]; then
    return
  fi
  db_new_file=${db_file}_new
  if [ -f "$db_file" ]; then
    awk '$1 != "'"$test_dir"'" {print $0}' $db_file >$db_new_file
    rm $db_file
    mv $db_new_file $db_file
  fi
  dir_escaped=$(echo "$test_dir" | sed -e 's/ /\\\\ /g')
  echo "JRE_VERSION	$dir_escaped	$ver_major	$ver_minor	$ver_micro	$ver_patch" >>$db_file
  echo "JRE_INFO	$dir_escaped	$is_openjdk" >>$db_file
}

test_jvm() {
  tested_jvm=na
  test_dir=$1
  bin_dir=$test_dir/bin
  java_exc=$bin_dir/java
  if [ -z "$test_dir" ] || [ ! -d "$bin_dir" ] || [ ! -f "$java_exc" ] || [ ! -x "$java_exc" ]; then
    return
  fi

  tested_jvm=false
  read_db_entry || create_db_entry $2

  if [ "$ver_major" = "" ]; then
    return
  fi
  if [ "$ver_major" -lt "1" ]; then
    return
  elif [ "$ver_major" -eq "1" ]; then
    if [ "$ver_minor" -lt "6" ]; then
      return
    fi
  fi

  if [ "$ver_major" = "" ]; then
    return
  fi
  app_java_home=$test_dir
}

add_class_path() {
  if [ -n "$1" ] && [ $(expr "$1" : '.*\*') -eq "0" ]; then
    local_classpath="$local_classpath${local_classpath:+:}$1"
  fi
}

compiz_workaround() {
  if [ "$is_openjdk" != "0" ]; then
    return
  fi
  if [ "$ver_major" = "" ]; then
    return
  fi
  if [ "$ver_major" -gt "1" ]; then
    return
  elif [ "$ver_major" -eq "1" ]; then
    if [ "$ver_minor" -gt "6" ]; then
      return
    elif [ "$ver_minor" -eq "6" ]; then
      if [ "$ver_micro" -gt "0" ]; then
        return
      elif [ "$ver_micro" -eq "0" ]; then
        if [ "$ver_patch" -gt "09" ]; then
          return
        fi
      fi
    fi
  fi

  osname=$(uname -s)
  if [ "$osname" = "Linux" ]; then
    compiz=$(ps -ef | grep -v grep | grep compiz)
    if [ -n "$compiz" ]; then
      export AWT_TOOLKIT=MToolkit
    fi
  fi

  app_java_home=$test_dir
}

read_vmoptions() {
  vmoptions_file=$(eval echo "$1" 2>/dev/null)
  if [ ! -r "$vmoptions_file" ]; then
    vmoptions_file="$prg_dir/$vmoptions_file"
  fi
  if [ -r "$vmoptions_file" ]; then
    # * cmd < file
    # 使cmd命令从file读入
    # exec 8< "$vmoptions_file" 表示 exec 执行来自文件描符8 文件描述符8来从文件$vmoptions_file中读出
    exec 8<"$vmoptions_file"
    # while read cur_option<&8; do
    # 将读入的内容赋值到 cur_option 变量
    while read cur_option <&8; do
      # expr 执行表达式
      # : 'W *-classpath \(.*\)'`: 字符串匹配 -classpath * 的内容。
      # vmo_classpath=`expr "W$cur_option" : 'W *-classpath \(.*\)'`
      # 将读出的cur_option内容 匹配-classpath *，匹配到的内容存入vmo_classpath
      is_comment=$(expr "W$cur_option" : 'W *#.*')
      if [ "$is_comment" = "0" ]; then
        vmo_classpath=$(expr "W$cur_option" : 'W *-classpath \(.*\)')
        vmo_classpath_a=$(expr "W$cur_option" : 'W *-classpath/a \(.*\)')
        vmo_classpath_p=$(expr "W$cur_option" : 'W *-classpath/p \(.*\)')
        vmo_include=$(expr "W$cur_option" : 'W *-include-options \(.*\)')
        if [ ! "$vmo_classpath" = "" ]; then
          local_classpath="$i4j_classpath:$vmo_classpath"
        elif [ ! "$vmo_classpath_a" = "" ]; then
          local_classpath="${local_classpath}:${vmo_classpath_a}"
        elif [ ! "$vmo_classpath_p" = "" ]; then
          local_classpath="${vmo_classpath_p}:${local_classpath}"
        elif [ "$vmo_include" = "" ]; then
          if [ "W$vmov_1" = "W" ]; then
            vmov_1="$cur_option"
          elif [ "W$vmov_2" = "W" ]; then
            vmov_2="$cur_option"
          elif [ "W$vmov_3" = "W" ]; then
            vmov_3="$cur_option"
          elif [ "W$vmov_4" = "W" ]; then
            vmov_4="$cur_option"
          elif [ "W$vmov_5" = "W" ]; then
            vmov_5="$cur_option"
          else
            vmoptions_val="$vmoptions_val $cur_option"
          fi
        fi
      fi
    done

    # cmd <&- 关闭标准输入
    # exec 8<&- 表示关闭文件描述符8
    exec 8<&-
    if [ ! "$vmo_include" = "" ]; then
      read_vmoptions "$vmo_include"
    fi
  fi
}

run_unpack200() {
  if [ -f "$1/lib/rt.jar.pack" ]; then
    old_pwd200=$(pwd)
    cd "$1"
    echo "Preparing JRE ..."
    jar_files="lib/rt.jar lib/charsets.jar lib/plugin.jar lib/deploy.jar lib/ext/localedata.jar lib/jsse.jar"
    for jar_file in $jar_files; do
      if [ -f "${jar_file}.pack" ]; then
        bin/unpack200 -r ${jar_file}.pack $jar_file

        if [ $? -ne 0 ]; then
          echo "Error unpacking jar files. The architecture or bitness (32/64)"
          echo "of the bundled JVM might not match your machine."
          echo "You might also need administrative privileges for this operation."
          exit 1
        fi
      fi
    done
    cd "$old_pwd200"
  fi
}

old_pwd=$(pwd)

progname=$(basename "$0")
linkdir=$(dirname "$0")

cd "$linkdir"
prg="$progname"

while [ -h "$prg" ]; do
  ls=$(ls -ld "$prg")
  link=$(expr "$ls" : '.*-> \(.*\)$')
  if expr "$link" : '.*/.*' >/dev/null; then
    prg="$link"
  else
    prg="$(dirname $prg)/$link"
  fi
done

prg_dir=$(dirname "$prg")
progname=$(basename "$prg")
cd "$prg_dir"
prg_dir=$(pwd)
app_home=../
cd "$app_home"
app_home=$(pwd)
bundled_jre_home="$app_home/jre"

if [ "__i4j_lang_restart" = "$1" ]; then
  cd "$old_pwd"
else
  cd "$prg_dir"/.
fi
if [ ! "__i4j_lang_restart" = "$1" ]; then
  run_unpack200 "$bundled_jre_home"
  run_unpack200 "$bundled_jre_home/jre"
fi
if [ -z "$app_java_home" ]; then
  test_jvm $INSTALL4J_JAVA_HOME_OVERRIDE
fi

if [ -z "$app_java_home" ]; then
  if [ -f "$app_home/.install4j/pref_jre.cfg" ]; then
    read file_jvm_home <"$app_home/.install4j/pref_jre.cfg"
    test_jvm "$file_jvm_home"
    if [ -z "$app_java_home" ] && [ $tested_jvm = "false" ]; then
      rm $db_file
      test_jvm "$file_jvm_home"
    fi
  fi
fi

if [ -z "$app_java_home" ]; then
  test_jvm "$app_home/jre"
  if [ -z "$app_java_home" ] && [ $tested_jvm = "false" ]; then
    rm $db_file
    test_jvm "$app_home/jre"
  fi
fi

if [ -z "$app_java_home" ]; then
  path_java=$(which java 2>/dev/null)
  path_java_home=$(expr "$path_java" : '\(.*\)/bin/java$')
  test_jvm $path_java_home
fi

if [ -z "$app_java_home" ]; then
  common_jvm_locations="/opt/i4j_jres/* /usr/local/i4j_jres/* $HOME/.i4j_jres/* /usr/bin/java* /usr/bin/jdk* /usr/bin/jre* /usr/bin/j2*re* /usr/bin/j2sdk* /usr/java* /usr/jdk* /usr/jre* /usr/j2*re* /usr/j2sdk* /usr/java/j2*re* /usr/java/j2sdk* /opt/java* /usr/java/jdk* /usr/java/jre* /usr/lib/java/jre /usr/local/java* /usr/local/jdk* /usr/local/jre* /usr/local/j2*re* /usr/local/j2sdk* /usr/jdk/java* /usr/jdk/jdk* /usr/jdk/jre* /usr/jdk/j2*re* /usr/jdk/j2sdk* /usr/lib/jvm/* /usr/lib/java* /usr/lib/jdk* /usr/lib/jre* /usr/lib/j2*re* /usr/lib/j2sdk* /System/Library/Frameworks/JavaVM.framework/Versions/1.?/Home"
  for current_location in $common_jvm_locations; do
    if [ -z "$app_java_home" ]; then
      test_jvm $current_location
    fi

  done
fi
# -z “STRING” 的长度为零则为真
if [ -z "$app_java_home" ]; then
  test_jvm $JAVA_HOME
fi

if [ -z "$app_java_home" ]; then
  test_jvm $JDK_HOME
fi

if [ -z "$app_java_home" ]; then
  test_jvm $INSTALL4J_JAVA_HOME
fi

if [ -z "$app_java_home" ]; then
  if [ -f "$app_home/.install4j/inst_jre.cfg" ]; then
    read file_jvm_home <"$app_home/.install4j/inst_jre.cfg"
    test_jvm "$file_jvm_home"
    if [ -z "$app_java_home" ] && [ $tested_jvm = "false" ]; then
      rm $db_file
      test_jvm "$file_jvm_home"
    fi
  fi
fi

if [ -z "$app_java_home" ]; then
  echo No suitable Java Virtual Machine could be found on your system.
  echo The version of the JVM must be at least 1.6.
  echo Please define INSTALL4J_JAVA_HOME to point to a suitable JVM.
  echo You can also try to delete the JVM cache file $db_file
  exit 83
fi

compiz_workaround
i4j_classpath="$app_home/.install4j/i4jruntime.jar"
local_classpath=""
add_class_path "$i4j_classpath"
for i in $(ls "$app_home/UST/lib" 2>/dev/null | egrep "\.(jar$|zip$)"); do
  add_class_path "$app_home/UST/lib/$i"
done
for i in $(ls "$app_home/UST/lib/Jetty" 2>/dev/null | egrep "\.(jar$|zip$)"); do
  add_class_path "$app_home/UST/lib/Jetty/$i"
done
for i in $(ls "$app_home/UST/extensions/__lib__" 2>/dev/null | egrep "\.(jar$|zip$)"); do
  add_class_path "$app_home/UST/extensions/__lib__/$i"
done
add_class_path "$app_home/UST"

vmoptions_val=""
read_vmoptions "$prg_dir/$progname.vmoptions"
INSTALL4J_ADD_VM_PARAMS="$INSTALL4J_ADD_VM_PARAMS $vmoptions_val"

INSTALL4J_ADD_VM_PARAMS="$INSTALL4J_ADD_VM_PARAMS -Di4j.vpt=true"
for param in $@; do
  if [ $(echo "W$param" | cut -c -3) = "W-J" ]; then
    INSTALL4J_ADD_VM_PARAMS="$INSTALL4J_ADD_VM_PARAMS $(echo "$param" | cut -c 3-)"
  fi
done

if [ "W$vmov_1" = "W" ]; then
  vmov_1="-Di4j.vmov=true"
fi
if [ "W$vmov_2" = "W" ]; then
  vmov_2="-Di4j.vmov=true"
fi
if [ "W$vmov_3" = "W" ]; then
  vmov_3="-Di4j.vmov=true"
fi
if [ "W$vmov_4" = "W" ]; then
  vmov_4="-Di4j.vmov=true"
fi
if [ "W$vmov_5" = "W" ]; then
  vmov_5="-Di4j.vmov=true"
fi

case "$1" in
start)
  echo "Starting ust-service"

  $INSTALL4J_JAVA_PREFIX nohup "$app_java_home/bin/java" -server -Dinstall4j.jvmDir="$app_java_home" -Dexe4j.moduleName="$prg_dir/$progname" "-Dfile.encoding=UTF-8" "-Dinstall4j.launcherId=23" "-Dinstall4j.swt=false" "$vmov_1" "$vmov_2" "$vmov_3" "$vmov_4" "$vmov_5" $INSTALL4J_ADD_VM_PARAMS -Xloggc:logs/gc$(date +%Y%m%d%H%M%S).log -classpath "$local_classpath" com.install4j.runtime.launcher.Launcher start com.ultraskytree.v2.Main false false "" "" true true false "sfs-splash.png" true true 0 0 "" 20 20 "Arial" "0,0,0" 8 500 "version 2.0.1" 20 40 "Arial" "0,0,0" 8 500 -1 >/dev/null 2>&1 &

  ;;

start-launchd)
  echo "Starting ust-service"

  $INSTALL4J_JAVA_PREFIX "$app_java_home/bin/java" -server -Dinstall4j.jvmDir="$app_java_home" -Dexe4j.moduleName="$prg_dir/$progname" "-Dfile.encoding=UTF-8" "-Dinstall4j.launcherId=23" "-Dinstall4j.swt=false" "$vmov_1" "$vmov_2" "$vmov_3" "$vmov_4" "$vmov_5" $INSTALL4J_ADD_VM_PARAMS -classpath "$local_classpath" com.install4j.runtime.launcher.Launcher start com.ultraskytree.v2.Main false false "" "" true true false "sfs-splash.png" true true 0 0 "" 20 20 "Arial" "0,0,0" 8 500 "version 2.0.1" 20 40 "Arial" "0,0,0" 8 500 -1

  ;;

stop)
  echo "Shutting down ust-service"

  $INSTALL4J_JAVA_PREFIX "$app_java_home/bin/java" -server -Dinstall4j.jvmDir="$app_java_home" -Dexe4j.moduleName="$prg_dir/$progname" -classpath "$local_classpath" com.install4j.runtime.launcher.Launcher stop

  ;;

restart | force-reload)
  echo "Shutting down ust-service"

  $INSTALL4J_JAVA_PREFIX "$app_java_home/bin/java" -server -Dinstall4j.jvmDir="$app_java_home" -Dexe4j.moduleName="$prg_dir/$progname" -classpath "$local_classpath" com.install4j.runtime.launcher.Launcher stop

  echo "Restarting ust-service"

  $INSTALL4J_JAVA_PREFIX nohup "$app_java_home/bin/java" -server -Dinstall4j.jvmDir="$app_java_home" -Dexe4j.moduleName="$prg_dir/$progname" "-Dfile.encoding=UTF-8" "-Dinstall4j.launcherId=23" "-Dinstall4j.swt=false" "$vmov_1" "$vmov_2" "$vmov_3" "$vmov_4" "$vmov_5" $INSTALL4J_ADD_VM_PARAMS -classpath "$local_classpath" com.install4j.runtime.launcher.Launcher start com.ultraskytree.v2.Main false false "" "" true true false "sfs-splash.png" true true 0 0 "" 20 20 "Arial" "0,0,0" 8 500 "version 2.0.1" 20 40 "Arial" "0,0,0" 8 500 -1 >/dev/null 2>&1 &

  ;;

status)

  $INSTALL4J_JAVA_PREFIX "$app_java_home/bin/java" -server -Dinstall4j.jvmDir="$app_java_home" -Dexe4j.moduleName="$prg_dir/$progname" -classpath "$local_classpath" com.install4j.runtime.launcher.Launcher status

  ;;

*)
  echo "Usage: $0 {start|stop|status|restart|force-reload}"
  exit 1
  ;;
esac

exit $?

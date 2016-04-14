#!/bin/bash

cpus="0,1"

if [[ $# == 0 ]]; then
	echo "no key specified (start, stop, version, status)" >&2
	exit 1
fi

function printAllJavaProcessAffinities {
	echo "the following java processes are running now:"
	for pid in $(ps aux | grep java | grep -v "grep" | grep hadoop | awk '{print $2}'); do
		echo "$pid: $(taskset -cp ${pid})"
		for p in $(ls /proc/$pid/task); do
			echo "        $p: $(taskset -cp $p)"
		done
	done
}

function printJavaProcessAffinities {
	echo "the following java processes are running now:"
	for pid in $(ps aux | grep java | grep -v "grep" | grep hadoop | awk '{print $2}'); do
		name=$(ps aux | grep java | grep -v "grep" | grep hadoop | grep $pid | awk '{print $12}')
		echo "  $pid: $(taskset -cp ${pid}) ($name)"
	done
}

function setJavaProcessAffinities {
	cpu=$1
	for pid in $(ps aux | grep java | grep -v "grep" | grep hadoop | awk '{print $2}'); do
		taskset -p -c $cpu $pid
		for p in $(ls /proc/${pid}/task); do
			taskset -p -c $cpu $p
		done
	done
}

case $1 in
	"start" )
		echo "START:"
		$HADOOP_PREFIX/bin/start-dfs.sh
		$HADOOP_PREFIX/bin/start-mapred.sh
		$HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave
		# sleep 1
		# setJavaProcessAffinities $cpus
		# printJavaProcessAffinities
		echo "START: DONE" ;;
	"stop" )
		echo "STOP:"
		$HADOOP_PREFIX/bin/stop-mapred.sh
		$HADOOP_PREFIX/bin/stop-dfs.sh ;;
	"version" )
		echo "VERSION:"
		ls -alh /usr/local | grep "hadoop \->" ;;
	"status" )
		echo "STATUS: $(ps aux | grep java | grep -v grep | grep hadoop | wc -l | xargs) running"
		printJavaProcessAffinities
		echo "STATUS: DONE" ;;
	* )
		echo "invalid key specified (start, stop, version, status)" ;;
esac
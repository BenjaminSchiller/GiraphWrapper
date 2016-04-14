#!/bin/bash

if [[ ! $# == "6" ]]; then
	echo "giraph: expecting 6 arguments, $# given" >&2
	echo "DATASET BATCHES PARTITIONING METRIC WORKERS RUN" >&2
	exit
fi

function join { local IFS="$1"; shift; echo "$*"; }

function setJavaProcessAffinities {
	cpu=$1
	for pid in $(ps aux | grep java | grep -v "grep" | grep hadoop | awk '{print $2}'); do
		taskset -p -c $cpu $pid
		for p in $(ls /proc/${pid}/task); do
			taskset -p -c $cpu $p
		done
	done
}

function printTime {
	if [[ -d /Users/benni ]]; then
		gdate +%s%N
	else
		date +%s%N
	fi
}

function start {
	startTimestamp=$(printTime)
	date
	echo "start: $startTimestamp"
}

function end {
	endTimestamp=$(printTime)
	date
	echo "end: $endTimestamp"
	echo "duration: $((endTimestamp - startTimestamp))"
}

function setArgs {
	case "$METRIC" in
		"GIRAPH_WEAK_CONNECTIVITY" )
			SUFFIX=".EdgeList"
			ARGS="org.apache.giraph.examples.ConnectedComponentsComputation\
,-eif,org.apache.giraph.io.formats.IntNullTextEdgeInputFormat\
,-eip,INPUT_FILE\
,-op,OUTPUT_DIR\
,-w,$WORKERS"
			;;
		"GIRAPH_TRIANGLE_CLOSING" )
			SUFFIX=".EdgeList"
			ARGS="org.apache.giraph.examples.SimpleTriangleClosingComputation\
,-eif,org.apache.giraph.io.formats.IntNullTextEdgeInputFormat\
,-eip,INPUT_FILE\
,-op,OUTPUT_DIR\
,-w,$WORKERS"
			;;
		"GIRAPH_SSSP" )
			SUFFIX=".EdgeList"
			ARGS="org.apache.giraph.examples.SimpleShortestPathsComputation"
			;;
		"GIRAPH_IN_DEGREE" )
			SUFFIX=".EdgeList"
			ARGS="org.apache.giraph.examples.SimpleInDegreeCountComputation"
			;;
		"GIRAPH_OUT_DEGREE" )
			SUFFIX=".EdgeList"
			ARGS="org.apache.giraph.examples.SimpleOutDegreeCountComputation"
			;;
		# "GIRAPH_" )
		# 	SUFFIX=".EdgeList"
		# 	ARGS=""
		# 	;;
		# "GIRAPH_" )
		# 	SUFFIX=".EdgeList"
		# 	ARGS=""
		# 	;;
		# "GIRAPH_" )
		# 	SUFFIX=".EdgeList"
		# 	ARGS=""
		# 	;;
		OKAPI_CLUSTERING_COEFFICIENT )
			SUFFIX=".EdgeList"
			ARGS="ml.grafos.okapi.graphs.ClusteringCoefficient\$SendFriendsList\
,-mc,ml.grafos.okapi.graphs.ClusteringCoefficient\$MasterCompute\
,-eif,ml.grafos.okapi.io.formats.LongNullTextEdgeInputFormat\
,-eip,INPUT_FILE\
,-vof,org.apache.giraph.io.formats.IdWithValueTextOutputFormat\
,-op,OUTPUT_DIR\
,-w,$WORKERS\
,-ca,giraph.oneToAllMsgSending=true"
			;;
		OKAPI_JACCARD_EXACT )
			SUFFIX=".EdgeList"
			ARGS="ml.grafos.okapi.graphs.similarity.Jaccard\$SendFriendsList\
,-mc,ml.grafos.okapi.graphs.similarity.Jaccard\$MasterCompute\
,-eif,ml.grafos.okapi.io.formats.LongDoubleZerosTextEdgeInputFormat\
,-eip,INPUT_FILE\
,-eof,org.apache.giraph.io.formats.SrcIdDstIdEdgeValueTextOutputFormat\
,-op,OUTPUT_DIR\
,-w,$WORKERS\
,-ca,giraph.oneToAllMsgSending=true\
,-ca,giraph.outEdgesClass=org.apache.giraph.edge.HashMapEdges"
			;;
		OKAPI_JACCARD_APPROX )
			SUFFIX=".EdgeList"
			ARGS="ml.grafos.okapi.graphs.similarity.Jaccard\$SendFriendsBloomFilter\
,-mc,ml.grafos.okapi.graphs.similarity.Jaccard\$MasterCompute\
,-eif,ml.grafos.okapi.io.formats.LongDoubleZerosTextEdgeInputFormat\
,-eip,INPUT_FILE\
,-eof,org.apache.giraph.io.formats.SrcIdDstIdEdgeValueTextOutputFormat\
,-op,OUTPUT_DIR\
,-w,$WORKERS\
,-ca,giraph.oneToAllMsgSending=true\
,-ca,giraph.outEdgesClass=org.apache.giraph.edge.HashMapEdges\
,-ca,jaccard.approximation.enabled=true"
			;;
		OKAPI_TRIANGLES_COUNT )
			SUFFIX=".EdgeList"
			ARGS="ml.grafos.okapi.graphs.Triangles\$Initialize\
,-mc,ml.grafos.okapi.graphs.Triangles\$TriangleCount\
,-eif,ml.grafos.okapi.io.formats.LongNullTextEdgeInputFormat\
,-eip,INPUT_FILE\
,-vof,ml.grafos.okapi.graphs.Triangles\$TriangleOutputFormat\
,-op,OUTPUT_DIR\
,-w,$WORKERS\
,-ca,giraph.outEdgesClass=org.apache.giraph.edge.HashMapEdges"
			;;
		OKAPI_TRIANGLES_LIST )
			SUFFIX=".EdgeList"
			ARGS="ml.grafos.okapi.graphs.Triangles\$Initialize\
,-mc,ml.grafos.okapi.graphs.Triangles\$TriangleFind\
,-eif,ml.grafos.okapi.io.formats.LongNullTextEdgeInputFormat\
,-eip,INPUT_FILE\
,-vof,ml.grafos.okapi.graphs.Triangles\$TriangleOutputFormat\
,-op,OUTPUT_DIR\
,-w,$WORKERS\
,-ca,giraph.outEdgesClass=org.apache.giraph.edge.HashMapEdges"
			;;
		OKAPI_MSSP_FRACTION_* )
			SOURCES_FRACTION=${METRIC#OKAPI_MSSP_FRACTION_}
			SUFFIX=".WeightedEdgeList"
			ARGS="ml.grafos.okapi.graphs.MultipleSourceShortestPaths\$InitSources\
,-mc,ml.grafos.okapi.graphs.MultipleSourceShortestPaths\$MasterCompute\
,-eif,ml.grafos.okapi.io.formats.LongFloatTextEdgeInputFormat\
,-eip,INPUT_FILE\
,-vof,org.apache.giraph.io.formats.IdWithValueTextOutputFormat\
,-op,OUTPUT_DIR\
,-w,$WORKERS\
,-ca,sources.fraction=$SOURCES_FRACTION"
			;;
		OKAPI_MSSP_LIST_* )
			SOURCES_LIST=${METRIC#OKAPI_MSSP_LIST_}
			SUFFIX=".WeightedEdgeList"
			ARGS="ml.grafos.okapi.graphs.MultipleSourceShortestPaths\$InitSources\
,-mc,ml.grafos.okapi.graphs.MultipleSourceShortestPaths\$MasterCompute\
,-eif,ml.grafos.okapi.io.formats.LongFloatTextEdgeInputFormat\
,-eip,INPUT_FILE\
,-vof,org.apache.giraph.io.formats.IdWithValueTextOutputFormat\
,-op,OUTPUT_DIR\
,-w,$WORKERS\
,-ca,sources.list=$SOURCES_LIST"
			;;
		* )
			echo "$1 is an invalid metric keyword" >&2
			exit 1
	esac
}

DATASET=$1
BATCHES=$2
PARTITIONING=$3
METRIC=$4
WORKERS=$5
RUN=$6

# set basic arguments
FROM="0"
TO="$BATCHES"
setArgs $METRIC $WORKERS

# INPUT
INPUT_LOCAL="datasets/$DATASET/"
INPUT_HADOOP="/user/hduser/input/$DATASET/"
INPUT_HADOOP="/user/hduser/input/"

# OUTPUT
OUTPUT_LOCAL="output/$DATASET/$BATCHES/$PARTITIONING/$METRIC/$WORKERS/$RUN/"
OUTPUT_HADOOP="/user/hduser/output/$DATASET/$BATCHES/$PARTITIONING/$METRIC/$WORKERS/$RUN/"
OUTPUT_HADOOP="/user/hduser/output/"
OUTPUT_SUCCESS_LOG="output/$DATASET/$BATCHES/$PARTITIONING/$METRIC/$WORKERS/$RUN/_SUCCESS"

# RESULT
RESULT_DIR="results/$DATASET/$BATCHES/$PARTITIONING/$METRIC/$WORKERS"
RESULT_FILE="$RESULT_DIR/$RUN.dat"

# SKIP if result exists already
if [[ -f $RESULT_FILE ]]; then
	echo "$RESULT_FILE already exists, skipping"
	exit 0
fi

$HADOOP_PREFIX/bin/hadoop fs -rmr $INPUT_HADOOP 2>&1
$HADOOP_PREFIX/bin/hadoop fs -rmr $OUTPUT_HADOOP 2>&1

# COPY LOCAL INPUT TO HADOOP
$HADOOP_PREFIX/bin/hadoop fs -copyFromLocal $INPUT_LOCAL $INPUT_HADOOP


# CREATE LOCAL DIRS
if [[ ! -d $OUTPUT_LOCAL ]]; then mkdir -p $OUTPUT_LOCAL; fi
if [[ ! -d $RESULT_DIR ]]; then mkdir -p $RESULT_DIR; fi

# OUTPUT SETTINGS
echo "INPUT_LOCAL:        $INPUT_LOCAL"
echo "INPUT_HADOOP:       $INPUT_HADOOP"
echo "OUTPUT_LOCAL:       $OUTPUT_LOCAL"
echo "OUTPUT_HADOOP:      $OUTPUT_HADOOP"
echo "OUTPUT_SUCCESS_LOG: $OUTPUT_SUCCESS_LOG"
echo "RESULT_DIR:         $RESULT_DIR"
echo "RESULT_FILE:        $RESULT_FILE"
echo "SUFFIX:             $SUFFIX"
echo "FROM/TO:            $FROM/$TO"


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# MAIN EXECUTION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# DETERMINE CPUS TO USE
CPUS=$(join , $(seq 1 $((WORKERS+2))))
bla=$(setJavaProcessAffinities $CPUS 2>&1)

# OUTPUT START TIME & CPU STATS
start > $RESULT_FILE
echo "CPUS: $CPUS" >> $RESULT_FILE

# LIBJARS="/home/hduser/giraphWrapper/lib/ArgList.jar,/home/hduser/giraphWrapper/lib/commons-configuration-1.10.jar,/home/hduser/giraphWrapper/lib/commons-lang-2.6.jar,/home/hduser/giraphWrapper/lib/commons-logging-1.2.jar,/home/hduser/giraphWrapper/lib/giraph-examples-1.2.0-SNAPSHOT-for-hadoop-1.2.1-jar-with-dependencies.jar,/home/hduser/giraphWrapper/lib/hadoop-core-1.2.1.jar,/home/hduser/giraphWrapper/lib/okapi-0.3.5-SNAPSHOT-jar-with-dependencies.jar"
# export JAVA_CLASSPATH="/home/hduser/giraphWrapper/lib/ArgList.jar:/home/hduser/giraphWrapper/lib/commons-configuration-1.10.jar:/home/hduser/giraphWrapper/lib/commons-lang-2.6.jar:/home/hduser/giraphWrapper/lib/commons-logging-1.2.jar:/home/hduser/giraphWrapper/lib/giraph-examples-1.2.0-SNAPSHOT-for-hadoop-1.2.1-jar-with-dependencies.jar:/home/hduser/giraphWrapper/lib/hadoop-core-1.2.1.jar:/home/hduser/giraphWrapper/lib/okapi-0.3.5-SNAPSHOT-jar-with-dependencies.jar"

# EXECUTE WITH GIRAPH WRAPPER
# echo java -cp "giraph.jar:lib/*" giraph.wrapper.GiraphWrapper $INPUT_HADOOP $SUFFIX $FROM $TO $OUTPUT_HADOOP $ARGS
# taskset -c $CPUS java -cp "giraph.jar:lib/*" giraph.wrapper.GiraphWrapper $INPUT_HADOOP $SUFFIX $FROM $TO $OUTPUT_HADOOP $ARGS 2>&1 | tee -a $RESULT_FILE
# java -cp "giraph.jar:lib/*" giraph.wrapper.GiraphWrapper $INPUT_HADOOP $SUFFIX $FROM $TO $OUTPUT_HADOOP $ARGS 2>&1 | tee -a $RESULT_FILE
$HADOOP_PREFIX/bin/hadoop jar giraph.jar giraph.wrapper.GiraphWrapper $INPUT_HADOOP $SUFFIX $FROM $TO $OUTPUT_HADOOP $ARGS 2>&1 | tee -a $RESULT_FILE

# COPY HADOOP OUTPUT TO LOCAL
$HADOOP_PREFIX/bin/hadoop dfs -get ${OUTPUT_HADOOP}0/* $OUTPUT_LOCAL

# OUTPUT ERROR IN CASE EXECUTION WAS NOT SUCCESSFULL
# if [[ ! -f $OUTPUT_SUCCESS_LOG ]]; then
	# echo "$OUTPUT_SUCCESS_LOG does not exist!" >&2
if [[ $(cat $RESULT_FILE | grep "Total (ms)" | wc -l) -lt "1" ]]; then
	echo "job failed!" >&2
	echo "see log below...." >&2
	cat $RESULT_FILE >&2
	echo "exit-value: 1" >> $RESULT_FILE
else
	echo "exit-value: $?" >> $RESULT_FILE
fi

# OUTUT END TIME
end >> $RESULT_FILE

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

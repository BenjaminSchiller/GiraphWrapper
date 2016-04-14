#!/bin/bash

if [[ ! -d plots ]]; then mkdir plots; fi



function durationTotal {
	grep "^duration:" $1 | cut -d ":" -f 2 | xargs
}

function durationGiraph {
	giraph="0"
	while IFS= read -r line ; do
		add=$(echo $line | cut -d "=" -f 2 | xargs)
		giraph=$((giraph + add))
	done < <(grep "Total (ms)" $1)
	#giraph=$((giraph*1000000))
	echo $giraph
	# grep "Total (ms)" $1 | cut -d "=" -f 2 | xargs
}

function plotByWorkers {
	dataset=$1
	batches=$2
	partitioning=$3
	metric=$4
	src="results/$dataset/$batches/$partitioning/$metric"
	dstDir="plots/byWorkers"
	if [[ ! -d $dstDir ]]; then mkdir -p $dstDir; fi
	dst="$dstDir/${metric//:/_}--$dataset-$partitioning-$batches.png"

	echo "set terminal png"
	echo "set output '$dst'"
	echo "set style fill solid"
	echo "set boxwidth 0.5"
	echo "set yrange [0:60]"
	echo "#set xrange [2:*]"
	echo "set xlabel '# of workers'"
	echo "set ylabel 'runtime (sec)'"
	echo "set title '$metric ($batches batches)'"

	# boxes, no aggregation
	echo "plot	'-' using (\$1+.25):((\$2)/1000/1000/1000):(0.5) with boxes lt 1 title 'total', \\"
	echo "		'-' using (\$1+.25):((\$2)/1000/1000/1000):(0.5) with lines lt 1 notitle, \\"
	echo "		'-' using (\$1):(((\$2)/1000/1000-(\$3))/1000):(0.5) with boxes lt 2 title 'overhead', \\"
	echo "		'-' using (\$1):(((\$2)/1000/1000-(\$3))/1000):(0.5) with lines lt 2 notitle, \\"
	echo "		'-' using (\$1-.25):((\$3)/1000):(0.5) with boxes lt 3 title 'giraph', \\"
	echo "		'-' using (\$1-.25):((\$3)/1000):(0.5) with lines lt 3 notitle"
	
	for i in $(seq 1 6); do
		for workers in $(ls $src | sort -n); do
			echo "$workers	$(durationTotal $src/$workers/0.dat)	$(durationGiraph $src/$workers/0.dat)"
		done
		echo "EOF"
	done
}

function plotByBatches {
	dataset=$1
	workers=$2
	partitioning=$3
	metric=$4
	src="results/$dataset/$batches/$partitioning/$metric"
	dstDir="plots/byBatches"
	if [[ ! -d $dstDir ]]; then mkdir -p $dstDir; fi
	dst="$dstDir/${metric//:/_}--$dataset-$partitioning-$workers.png"

	echo "set terminal png"
	echo "set key top left"
	echo "set output '$dst'"
	echo "set style fill solid"
	echo "set boxwidth 0.5"
	echo "set yrange [0:1400]"
	echo "#set xrange [0:*]"
	echo "set xlabel '# of snapshots'"
	echo "set ylabel 'runtime (sec)'"
	echo "set title '$metric ($workers workers)'"

	# boxes, no aggregation
	echo "plot	'-' using (\$1+1.25):((\$2)/1000/1000/1000):(0.5) with boxes lt 1 title 'total', \\"
	echo "		'-' using (\$1+1.25):((\$2)/1000/1000/1000):(0.5) with lines lt 1 notitle, \\"
	echo "		'-' using (\$1+1.00):(((\$2)/1000/1000-(\$3))/1000):(0.5) with boxes lt 2 title 'overhead', \\"
	echo "		'-' using (\$1+1.00):(((\$2)/1000/1000-(\$3))/1000):(0.5) with lines lt 2 notitle, \\"
	echo "		'-' using (\$1+0.75):((\$3)/1000):(0.5) with boxes lt 3 title 'giraph', \\"
	echo "		'-' using (\$1+0.75):((\$3)/1000):(0.5) with lines lt 3 notitle"
	
	for i in $(seq 1 6); do
		for batches in $(ls results/$dataset); do
			echo "$batches	$(durationTotal results/$dataset/$batches/$partitioning/$metric/$workers/0.dat)	$(durationGiraph results/$dataset/$batches/$partitioning/$metric/$workers/0.dat)"
		done
		echo "EOF"
	done
}


for dataset in $(ls results); do
	for batches in $(ls results/$dataset); do
		for partitioning in $(ls results/$dataset/$batches); do
			for metric in $(ls results/$dataset/$batches/$partitioning); do
				if [[ $(ls results/$dataset/$batches/$partitioning/$metric | wc -l) -gt "1" ]]; then
				echo "plotByWorkers $dataset $batches $partitioning $metric"
					# plotByWorkers $dataset $batches $partitioning $metric | gnuplot
				fi
			done
		done
	done
done

for dataset in $(ls results); do
	for batches in $(ls results/$dataset); do
		for partitioning in $(ls results/$dataset/$batches); do
			for metric in $(ls results/$dataset/$batches/$partitioning); do
				echo "plotByBatches $dataset 1 $partitioning $metric"
				plotByBatches $dataset 1 $partitioning $metric | gnuplot
			done
		done
		break
	done
done
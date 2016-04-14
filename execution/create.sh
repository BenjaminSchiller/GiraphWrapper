#!/bin/bash

# # # # # # # # # # # # # # # # # #
# # ./okapi.sh $metric $input $output $workers
# # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # #
# # metrics
# # # # # # # # # # # # # # # # # #
# OKAPI_CLUSTERING_COEFFICIENT
# OKAPI_WEAK_CONNECTIVITY
# OKAPI_TRIANGLE_COUNT
# OKAPI_TRIANGLE_FIND
# OKAPI_JACCARD
# # # # # # # # # # # # # # # # # #

# # # # # # # # # # # # # # # # # #
# # partitionings
# # # # # # # # # # # # # # # # # #
# HashPartitioning
# # # # # # # # # # # # # # # # # #

function job {
	dataset=$1
	batches=$2
	partitioning=$3
	metric=$4
	workers=$5
	run=$6

	echo "./giraph.sh $dataset $batches $partitioning $metric $workers $run"
}

function jobCreate {
	./jobs.sh create "$(job $@)"
}



datasets_R_10k_E=("Random-10000,20000-Random-0,0,50,50-99" "Random-10000,50000-Random-0,0,50,50-99" "Random-10000,100000-Random-0,0,50,50-99")
datasets_R_10k_B=("Random-10000,20000-Random-0,0,50,50-99" "Random-10000,20000-Random-0,0,100,100-99" "Random-10000,20000-Random-0,0,200,200-99")
datasets_R_100k_E=("Random-100000,200000-Random-0,0,50,50-99" "Random-100000,500000-Random-0,0,50,50-99" "Random-100000,1000000-Random-0,0,50,50-99")
datasets_R_100k_B=("Random-100000,200000-Random-0,0,50,50-99" "Random-100000,200000-Random-0,0,100,100-99" "Random-100000,200000-Random-0,0,200,200-99")
datasets_BA_10k_E=("BarabasiAlbert-10,40,9990,2-Random-0,0,50,50-99" "BarabasiAlbert-10,40,9990,5-Random-0,0,50,50-99" "BarabasiAlbert-10,40,9990,10-Random-0,0,50,50-99")
datasets_BA_10k_B=("BarabasiAlbert-10,40,9990,2-Random-0,0,50,50-99" "BarabasiAlbert-10,40,9990,2-Random-0,0,100,100-99" "BarabasiAlbert-10,40,9990,2-Random-0,0,200,200-99")


partitioning="HASH"
datasets=(${datasets_R_10k_E[@]})
runs=($(seq 0 0))
metrics=(OKAPI_CLUSTERING_COEFFICIENT)

batchess=(0); workerss=(1 2 4 8)
batchess=(0); workerss=(1)



datasets=("Random-10000,20000-Random-0,0,50,50-99")
metrics=(GIRAPH_WEAK_CONNECTIVITY OKAPI_CLUSTERING_COEFFICIENT OKAPI_TRIANGLES_COUNT OKAPI_TRIANGLES_LIST OKAPI_JACCARD_EXACT OKAPI_JACCARD_APPROX "OKAPI_MSSP_LIST_0" "OKAPI_MSSP_LIST_0:1" "OKAPI_MSSP_LIST_0:1:2:3" "OKAPI_MSSP_LIST_0:1:2:3:4:5:6:7" "OKAPI_MSSP_LIST_0:1:2:3:4:5:6:7:8:9:10:11:12:13:14:15")
batchess=(0); workerss=(1 2 4 8 16)
batchess=(1 3 7 15 31); workerss=(1)
runs=(0)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # RESET ALL
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# source jobs.cfg
# ssh $server_name "cd $server_dir; rm -r results/; rm -r output"
# ./jobs.sh trash done
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

./deploy.sh

for run in ${runs[@]}; do
	for dataset in ${datasets[@]}; do
		for batches in ${batchess[@]}; do
			for metric in ${metrics[@]}; do
				for workers in ${workerss[@]}; do
					jobCreate $dataset $batches $partitioning $metric $workers $run
				done
			done
		done
	done
done

#!/bin/bash

source jobs.cfg

if [[ ! $1 == "server" ]]; then
	ssh ${server_name} "cd ${server_dir}; ./datasets.sh server"
	exit
fi

format="WeightedEdgeList"
suffix=".$format"
src="/home/benni/pDNA/datasets"
dst="datasets"

if [[ ! -d $dst ]]; then mkdir -p $dst; fi

function dataset {
	name=$1
	batches=$2

	srcDir=$src/$name/
	dstDir=$dst/$name/

	if [[ ! -f $dstDir/0$suffix ]]; then
		java -jar dna2giraph.jar $srcDir 0.dnag .dnab $batches $dstDir $suffix $format
	fi
}

dataset BarabasiAlbert-10,40,9990,10-Random-0,0,50,50-99 99
dataset BarabasiAlbert-10,40,9990,2-Random-0,0,100,100-99 99
dataset BarabasiAlbert-10,40,9990,2-Random-0,0,200,200-99 99
dataset BarabasiAlbert-10,40,9990,2-Random-0,0,50,50-99 99
dataset BarabasiAlbert-10,40,9990,5-Random-0,0,50,50-99 99
dataset Random-10000,100000-Random-0,0,50,50-99 99
dataset Random-10000,20000-Random-0,0,100,100-99 99
dataset Random-10000,20000-Random-0,0,200,200-99 99
dataset Random-10000,20000-Random-0,0,50,50-99 99
dataset Random-10000,50000-Random-0,0,50,50-99 99
dataset Random-100000,1000000-Random-0,0,50,50-99 99
dataset Random-100000,200000-Random-0,0,100,100-99 99
dataset Random-100000,200000-Random-0,0,200,200-99 99
dataset Random-100000,200000-Random-0,0,50,50-99 99
dataset Random-100000,500000-Random-0,0,50,50-99 99

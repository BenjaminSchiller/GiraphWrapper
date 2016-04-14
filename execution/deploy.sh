#!/bin/bash

source jobs.cfg

rsync -auvzl ../../DNA.parallel/build/dna2giraph.jar ../build/giraph.jar ../java/lib giraph.sh hd.sh datasets.sh $server_name:$server_dir/
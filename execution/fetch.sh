#!/bin/bash

source jobs.cfg

if [[ ! -d "results" ]]; then mkdir results; fi

rsync -auvzl --prune-empty-dirs --include '*/' --include '*.dat' --exclude '*' "${server_name}:${server_dir}/results/*" ./results/
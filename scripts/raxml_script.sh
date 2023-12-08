#!/bin/bash

# exit when your script tries to use undeclared variables
set -o nounset
# exit if any pipe commands fail
set -o pipefail
# exit when a command fails
set -o errexit
# # trace what gets executed
# set -o xtrace

#raxml_script

# data inputs
FASTA_dir=../data/results/Aligned_fastas/
Output_dir=../data/results/bashML/

# output
# Raxml trees for each fasta


# 1. Making a loop to read through fastas with raxml
for fasta in $(ls ${FASTA_dir});
do
	name=$(basename ${fasta})
	filename=${name%.faa}
	raxmlHPC -s ${FASTA_dir}/${fasta} -n ${Output_dir}${filename}-scripted -m PROTGAMMAWAG -p 29813
done
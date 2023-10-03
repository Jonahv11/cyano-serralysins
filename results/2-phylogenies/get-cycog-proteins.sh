#!/bin/bash

# exit when your script tries to use undeclared variables
set -o nounset
# exit if any pipe commands fail
set -o pipefail
# exit when a command fails
set -o errexit
# # trace what gets executed
# set -o xtrace

# data inputs
CYCOGS=../1-serralysin-cycogs/data/serralysin_cycog_references.csv
REFS=../../data/genomes/

# output
# one fasta file for each CyCOG that contains nucleotide sequences of all
# proteins in that CyCOG

# 1. Separate out proteins of each CyCOG group
# make data directory
if [[ ! -d data/ ]]; then
    mkdir data
fi
# pull out entries for each cycog group into its own csv
for cycog in 60001830 60001883 60001888 60002365; do
    grep ${cycog} ${CYCOGS} >> data/${cycog}.csv
done

# 2. Concatenate all reference sequences
for genome in `tail -n +2 $CYCOGS | cut -d , -f 6 | sort | uniq`; do
    cat ${REFS}/${genome}/${genome}.genes.fna >> data/sequences.fna
done

# # 3. Pull out genes of each cycog group into unique fasta files
# for cycog in 60001830 60001883 60001888 60002365; do
#     echo ${cycog}
#     for geneid in `cut -d , -f 4 data/${cycog}.csv`; do
#         echo ${geneid}
#         # need to figure out how this awk command works
#         # awk 'BEGIN{RS=">"} /2717395913*/ && NR>1 { print ">" $0 }' data/sequences.fna 
#         # https://stackoverflow.com/questions/49731386/extract-sequences-from-multifasta-file-by-id-in-file-using-awk
#     done
# done

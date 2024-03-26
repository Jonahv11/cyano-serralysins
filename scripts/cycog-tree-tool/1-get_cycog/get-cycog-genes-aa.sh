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
CYCOGS=../../../data/serralysin_cycog_references.csv
REFS=../../../data/genomes/

# output
# one fasta file for each CyCOG that contains amino acit sequences of all
# proteins in that CyCOG

# 1. Separate out proteins of each CyCOG group
# make data directory
if [[ ! -d data/ ]]; then
    mkdir data
fi
# pull out gene for each cycog group into its own file
for cycog in 60001830 60001883 60001888 60002365; do
    grep ${cycog} ${CYCOGS} | cut -d , -f 4 >> data/${cycog}.txt
done

# 2. Concatenate all reference sequences
for genome in `tail -n +2 $CYCOGS | cut -d , -f 6 | sort | uniq`; do
    cat ${REFS}/${genome}/${genome}.genes.faa >> data/sequences.faa
done

# 3. Pull out genes of each cycog group into unique fasta files
for cycog in 60001830 60001883 60001888 60002365; do
    printf "Finding genes in CyCOG: ${cycog}\n"
    # reads the list of ids into an array, then compares the first field
    # of each record in the sequence files against the id list and 
    # prints out the matches
    awk 'NR==FNR{ids[$0]; next} ($1 in ids) { printf ">" $0 }' data/${cycog}.txt RS='>' data/sequences.faa >> data/${cycog}.genes.faa
    # anther slower solutino that loops over the sequence file over 
    # and over for each id being searched
    # for geneid in `cut -d , -f 4 data/${cycog}.csv`; do
    #     printf "\tsearching ${geneid}...\n"
    #     awk -v id="${geneid}" -v RS='>' '$1 == id {print RS $0}' data/sequences.fna >> data/${cycog}.genes.fna
    # done
done

# 4. clean up
rm data/*.txt
rm data/sequences.faa

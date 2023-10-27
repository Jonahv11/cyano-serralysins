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
REFS=../../data/genomes/
# file 4 of 
# downloaded from https://figshare.com/articles/dataset/File_4_CyCOG_taxa/6007166?backTo=/collections/Single_cell_genomes_of_i_Prochlorococcus_i_i_Synechococcus_i_and_sympatric_microbes_from_diverse_marine_environments/4037048
GENOMES=../../data/cycogs/cycogsgenomes.tsv
# file 5 of supplemental materials from Berube et al., 2018
# downloaded from https://figshare.com/articles/dataset/File_5_CyCOG_definitions/6007169?backTo=/collections/Single_cell_genomes_of_i_Prochlorococcus_i_i_Synechococcus_i_and_sympatric_microbes_from_diverse_marine_environments/4037048
CYCOG_LIST=../../data/cycogs/cycogs.tsv

# output
# one fasta file for each CyCOG that contains amino acid sequences of all
# proteins in that CyCOG

# 0. Collect user inputs
# user inputs cycog to be pulled
CYCOG=""
while [ "${CYCOG}" == "" ]; do
    printf "\nEnter CyCOG ID: "
    read CYCOG 
done
# user nucleotide or amino acid
SEQ=""
while [ "${SEQ}" == "" ]; do
    printf "\nEnter 'nt' for nucleotide or 'aa' for amino acid: "
    read selection 
    if [ "${selection}" == "nt" ]; then
        printf "\nPulling nucleotide sequences for all genes in CyCOG ${CYCOG}\n"
        SEQ="fna"
    elif [ "${selection}" == "aa" ]; then
        printf "\nPulling amino acid sequences for all genes in CyCOG ${CYCOG}\n"
        SEQ="faa"
    else 
        printf "\nInvalid selection\n"
    fi
done

# 1. Make a list of all the gene ids in the specified CyCOG
if [[ ! -d data/ ]]; then
    mkdir data
fi
for gene in `grep $CYCOG $CYCOG_LIST | cut -f 9 | awk -v FS="," '$1=$1'`; do 
    echo $gene | rev | cut -d'_' -f1 | rev
done >> data/${CYCOG}.txt

# 2. Concatenate all reference sequences
for genome in `tail -n +2 $GENOMES | cut -f 3 | sort | uniq`; do
    cat ${REFS}/${genome}/${genome}.genes.${SEQ} >> data/sequences.${SEQ}
done

# 3. Pull out all genes from specified CyCOG  into fasta file
# reads the list of ids into an array, then compares the first field
# of each record in the sequence files against the id list and 
# prints out the matches
awk 'NR==FNR{ids[$0]; next} ($1 in ids) { printf ">" $0 }' data/${CYCOG}.txt RS='>' data/sequences.${SEQ} >> data/${CYCOG}.genes.${SEQ}

# 4. clean up
rm data/${CYCOG}.txt
rm data/sequences.${SEQ}
printf "\nDone!\n"

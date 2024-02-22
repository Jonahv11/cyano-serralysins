#!/bin/bash

# exit when your script tries to use undeclared variables
set -o nounset
# exit if any pipe commands fail
set -o pipefail
# exit when a command fails
set -o errexit
# # trace what gets executed
# set -o xtrace

# file 4 of 
# downloaded from https://figshare.com/articles/dataset/File_4_CyCOG_taxa/6007166?backTo=/collections/Single_cell_genomes_of_i_Prochlorococcus_i_i_Synechococcus_i_and_sympatric_microbes_from_diverse_marine_environments/4037048
GENOMES=reference_files/cycogsgenomes.tsv
# file 5 of supplemental materials from Berube et al., 2018
# downloaded from https://figshare.com/articles/dataset/File_5_CyCOG_definitions/6007169?backTo=/collections/Single_cell_genomes_of_i_Prochlorococcus_i_i_Synechococcus_i_and_sympatric_microbes_from_diverse_marine_environments/4037048
CYCOG_LIST=reference_files/cycogs.tsv
# clade mappings provided as part of repository
CLADE_MAP=reference_files/updated-genome-clades.csv


# 0. Collect user inputs
# user inputs cycog to be pulled
CYCOG=""
while [ "${CYCOG}" == "" ]; do
    printf "\nEnter CyCOG ID: "
    read CYCOG 
done
FASTA=""
while [ "${FASTA}" == "" ]; do
    printf "\nEnter filepath of aligned fasta: "
    read FASTA 
done
# make data directory to keep intermediate files
if [[ ! -d data/ ]]; then
    mkdir data
fi
MAP_FILE="data/${CYCOG}-leaf-labels.tsv"

if [[ ! -e ${MAP_FILE} ]]; then 
    # 1. Match gene id to genome id
    TMP_MAP="data/gene-map.tmp"
    for CYCOG_STRING in `grep $CYCOG $CYCOG_LIST | cut -f 9 | awk -v FS="," '$1=$1'`; do 
        GENE=${CYCOG_STRING##*_}
        GENOME_NAME=${CYCOG_STRING%_*} 
        GENOME_ID=$(grep "${GENOME_NAME}" ${GENOMES} | cut -f 3)
        CLADE=$(grep "${GENOME_ID}" ${CLADE_MAP} | cut -d',' -f 3)
        printf "\n${GENE}\t${GENOME_ID}\t${GENOME_NAME}\t${CLADE}"
        printf "\n${GENE}\t${GENOME_ID}\t${GENOME_NAME}\t${CLADE}" >> ${TMP_MAP}
    done

    # 2. Match leaf labels to gene ids
    printf "leaf_id\tgene_id\tgenome_id\tgenome_name\tclade" >> ${MAP_FILE}
    for LEAF in `grep '^>' ${FASTA} | cut -d' ' -f 1 | cut -d'>' -f 2`; do
        GENE=$(echo ${LEAF} | cut -d'/' -f 1)
        GENE_MAP=$(grep "${GENE}" ${TMP_MAP})
        printf "\n${LEAF}\t${GENE_MAP}"
        printf "\n${LEAF}\t${GENE_MAP}" >> ${MAP_FILE}
    done
    rm ${TMP_MAP}
else
    echo "Existing file found: " ${MAP_FILE}
fi
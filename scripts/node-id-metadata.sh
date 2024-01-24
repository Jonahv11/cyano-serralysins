#!/bin/bash

# exit when your script tries to use undeclared variables
set -o nounset
# exit if any pipe commands fail
set -o pipefail
# exit when a command fails
set -o errexit
# # trace what gets executed
# set -o xtrace

# pull leaf labels from .faa file
grep '^>' 1830-aligned.faa | cut -d' ' -f 1 | cut -d'>' -f 2 >> leaf-labels.txt
# pull gene names from leaf labels
cat leaf-labels.txt | cut -d'/' -f 1 >> gene-names.txt
# match up gene names with metadata
# metadata.csv looks like:
# gene-name, attribute1, attribute2, attribute3

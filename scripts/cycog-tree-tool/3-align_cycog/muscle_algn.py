import os
import subprocess
from Bio import SeqIO
from Bio.Align.Applications import MuscleCommandline

# Get the input file path interactively
input_file = input("Enter the path to the input FASTA file: ")

# Check if the input file exists
if not os.path.isfile(input_file):
    print("Error: Input file not found.")
    exit()

# Generate the output file path based on the input file name
output_file = os.path.splitext(os.path.basename(input_file))[0] + "_aligned.fasta"

# Perform sequence alignment using Muscle via command line
muscle_cline = MuscleCommandline(input=input_file, out=output_file)
stdout, stderr = muscle_cline()

# Print the aligned sequences (optional)
aligned_sequences = list(SeqIO.parse(output_file, "fasta"))
print("Aligned sequences:")
for seq in aligned_sequences:
    print(f">{seq.id}")
    print(seq.seq)

print(f"Alignment saved to {output_file}")

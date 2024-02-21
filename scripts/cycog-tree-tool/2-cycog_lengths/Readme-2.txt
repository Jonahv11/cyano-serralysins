The fasta file will have some sequences that don't belong.
Many of these can be identified because their lengths are very different than the average sequence length.
First, using the fasta_length_hist.py script, create a histogram showing the length distribution of the fasta.
Next, using the histogram as reference, find the sequences with abnormal lengths relative to the fasta, and cut them out.
    This step is currently done using the software Jalview, but we may try to develop a script to do this in the future.
    There is no universal threshold for sequences falling out of the norm, but you can tell which sequences are short.
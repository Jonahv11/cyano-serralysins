After the alignment, there will be some long heads or tails of sequences on either side of the aligned regions.
These need to be trimmed so that the remaining sequences are only the aligned regions, or as close as possible to that.
While not all sequences will have these heads and tails, they will represent the first and last bases of the aligned fasta.
Trimming the heads and tails will not trim all sequences, only those with regions outside of the aligned region.
After trimming the heads and tails, realign the fasta.
This is all currently done within Jalview.
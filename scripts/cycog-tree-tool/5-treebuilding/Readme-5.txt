Taking this realigned fasta, you can now build a tree for the cycog. We currently use raxml for this process.
Raxml is used through the command line, with a function such as:
raxmlHPC -s ../Aligned_fastas/1830-aligned.faa  -n 1830-indiv  -m PROTGAMMAWAG -p 29813
raxmlHPC calls the program.
-s ../Aligned_fastas/1830-aligned.faa specifies the file and filepath to use for the treebuilding. (an aligned fasta)
-n 1830-indiv names the tree outputs, and can be directed with filepath as well.
-m PROTGAMMAWAG is the model used by Raxml. This model is used for amino acid fastas, rather than nucleotide fastas.
-p 29813 calibrates the bootstrapping. This "randomizes" the starting point for the tree building. The numbers are arbitrary.

I am developing a script to create multiple trees from multiple fastas with the same command.
raxml_script.sh has worked on my computer, but greater processing power is needed.
container_raxml.sh will be used on grazer or a different HPC environment when ready.
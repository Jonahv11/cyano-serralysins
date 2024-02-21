After the tree is made by raxml, it needs visualization for people to understand it.
You can import the raxml output starting with RAxML_bestTree into iTOL to get a quick view of the tree.
This basic view is not enough to make conclusions from, however. 
You can annotate or add context to the trees, giving information on clades, taxa, or almost anything else about the sequence.
This is done with annotation files.
I currently make annotation files manually using a template. I use colorstrip annotations.
To make annotations, leaf IDs on the tree need to be matched with gene/sequence information such as clade.
This is done using the node-id-metadata.sh script.
This script produces a .tsv file with information regarding each leaf ID.
The leaf ID is how you attribute information to the tree on iTOL.
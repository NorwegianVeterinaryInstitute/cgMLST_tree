params {
    // chewbbaca input - scheme must have been prepared 
    assemblies_dir =  ""
    schema_dir = ""

    // Cleaning alleles and making post cgMLST typing analyses 

    // raw_results = "$HOME/Documents/onedrive_sync/ONE_OBSIDIAN/GITS_WORK/cgMLST_tree/data/results_alleles_test.tsv"
    // number of missing alleles at maximum (nb loci scheme  - maxmissing = minimum accepted) 
    // "NULL" if no filtering otherwise "n"
    maxmissing = "NULL"
    // method "nj" or "single" for the clustering method 
    method =  "nj"
    // for the template making the phylogenetic tree
    author = "me" 
    // optional to define a different output directory: example 
    
    // outdir = "$HOME/results"
}

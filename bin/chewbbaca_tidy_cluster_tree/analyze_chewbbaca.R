if (!require("pacman")) {
  install.packages("pacman", dependencies = T) 
}
if (!require("optparse")) {
  install.packages("optparse", dependencies = T) 
}

require(optparse)

# example https://gist.github.com/ericminikel/8428297
# This is config file with defaults

option_list = list(
  make_option("--tidy_output", action="store", 
              default="tidy_cgMLST.tsv", type='character',
              help="Output file name for the tidied cgMLST typing. Will be in same directory as ChewBBACA results directory"),
  make_option(c("-d", "--directory"), action="store", 
              default="./", type='character',
              help="ChewBBACA results directory path"),
  make_option(c("-i", "--input"), action="store", type='character',
              default="results_alleles.tsv",
              help="ChewBBACA typing results file name if different than standard naming"),
  make_option("--script", action="store", 
              default="/mnt/2T/listeria/profficiency_2021/chewbbaca_tidy_cluster_tree/tidy_cgMLST_chewbbaca_functions.R",
              type='character',
              help="path/name of script that will tidy, create dissimilarity matrix, hierachical cluster and produce tree"), 
  make_option("--clustering_method", action="store", 
              default="single",
              type='character',
              help="Clustering option: 'single' = single linkage (default), 'nj' = neighbor joining"),
  make_option("--tree", action="store", 
              default="cluster.tree",
              type='character',
              help="Name of the tree file output. Newick format. Default = `cluster.tree`"),
  make_option("--assembly_extension", action="store", 
              default="(.fasta)|(.fna)",
              type='character',
              help="Extension of assembly names ie. default '(.fasta)|(.fna)"),
  make_option("--max_missing", action="store", 
              default="10",
              type='integer',
              help="maximum number of missing alleles in typing. Default 10")
  
)

opt = parse_args(OptionParser(option_list=option_list))

source(opt$script)

wrapper_call()






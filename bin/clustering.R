# hierarchical clustering 
# method NJ or SINGLE 
# setup 
library("pacman")
p_load(tidyverse, cluster, ape)

# Usage: Rscript <scriptname> <input.rds> <method> <output.nwk> 
# method: "single" or "nj"

args = commandArgs(trailingOnly=TRUE)

input <- args[1]
method <- args[2]
output <- args[3]

# test 
# input <- "dissimilarity.rds"
# method = "single"
# output <- "dissimilarity.tsv"

# script 
dissimilarity <- readRDS(input)

message("hierarchical clustering")

if (method == "single") {
  tree <- ape::as.phylo(hclust(dissimilarity, method))
} else if (method == "nj") {
    tree <- ape::nj(dissimilarity) 
    }
write.tree(tree, file = output)

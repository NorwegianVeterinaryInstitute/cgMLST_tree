# Computes the dissimilarity matrix distances - export as tsv
# export also rds for doing the clustering
# setup 
library("pacman")
p_load(tidyverse, cluster)


# Usage: Rscript <scriptname> <input> <output> 
args = commandArgs(trailingOnly=TRUE)

input <- args[1]
output <- args[2]

# # test 
# input <- "filtered_results_alleles.tsv"
# output <- "dissimilarity.tsv"

df <- 
  read_tsv(input, col_types = cols(.default = "c")) %>% 
  # Recheck if has to be factor  error otherwise 
  mutate_at(vars(-any_of("FILE")), as.factor) %>%
  column_to_rownames("FILE")

message("computing dissimilarity matrix with function: compute_dissimilarity_matrix")


dissimilarity <- daisy(df, metric = "gower")
saveRDS(dissimilarity, "dissimilarity.rds")


df <- 
  as.data.frame(as.matrix(dissimilarity), make.names = T) %>% 
  rownames_to_column(var = "FILE") 
write_tsv(df, output)
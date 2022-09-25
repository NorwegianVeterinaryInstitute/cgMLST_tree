# Computes the hamming distance - output a symetric matrix
# setup 
library("pacman")
p_load(tidyverse, cultevo)


# Usage: Rscript <scriptname> <input> <output> 
args = commandArgs(trailingOnly=TRUE)

input <- args[1]
output <- args[2]

# test 
# input <- "filtered_results_alleles.tsv"
# output <- "hamming_distances.tsv"

# hamming distances  
message("calculating hamming distances with function: calculate_hamming")


## import data 
df <- 
  read_tsv(input, col_types = cols(.default = "c")) %>%
  mutate_at(vars(-any_of("FILE")), as.factor) 

df_names <- df$FILE

## Transform for matrix ready
df <- df %>%
  column_to_rownames("FILE")

# compute distance and transform to symmetric matrix and to dataframe  
distances_df <- 
  as.data.frame(as.matrix(hammingdists(df))) %>%
  rownames_to_column(var = "FILE") 

# put the names in correct format 
names(distances_df) <- c("FILE", df_names)
distances_df$FILE <- df_names

# export the hamming distances results
write_tsv(distances_df, output)

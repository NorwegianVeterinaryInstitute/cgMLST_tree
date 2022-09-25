#!/usr/bin/env Rscript
# cleans labels from chewBBACA results
# extension cleaning: .fa AND .fasta
# Setup 
library("pacman")
p_load(tidyverse)

# Usage: Rscript <scriptname> <input> <output> 
args = commandArgs(trailingOnly=TRUE)

# import file - we need for checking ids 
df <- read_tsv(args[1], col_types = cols(.default = "c")) 

# checking all ids are unique 
message("checking for duplicate id in the dataset")

if (length(df$FILE) != length(unique(df$FILE))) {
  message("There are duplicated ids result file. This might happen if you have rerun twice the same isolates or
          if naming was incorrect. Please recheck the ids listed bellow.")
  
  duplicates <- which(duplicated(df$FILE))
  message("duplicates ids are: ", df$FILE[duplicates])
  stop()
} else {
  # tidying script
  message("OK: No duplicated ids detected")
  message("cleaning alleles data from chewBBACA results file")

  df %>%
    rename_with(function(x) str_remove_all(x, ".fasta|.fa"), everything()) %>% 
    mutate_at("FILE", function(x) str_remove_all (x, ".fasta|.fa|_contigs")) %>% 
    mutate_at(vars(-any_of("FILE")), function(x) str_remove(x, "INF-")) %>% 
    mutate_at(vars(-any_of("FILE")), 
            function(x) 
              str_replace_all(x, 
                              "(PLOT5)|(PLOT3)|(LNF)|(ASM)|(ALM)|(NIPH)|(NIPHEM) ",
                              NA_character_)) %>%
    mutate_at(vars(-any_of("FILE")), as.factor) %>%
    write_tsv(., args[2]) 

}
#!/usr/bin/env Rscript
# cleans labels from chewBBACA results
# extension cleaning: .fa AND .fasta
# Setup 
library("pacman")
p_load(tidyverse)

# Usage: Rscript <scriptname> <input> <output> 
args = commandArgs(trailingOnly=TRUE)

# tidying script
read_tsv(args[1], col_types = cols(.default = "c")) %>%
  rename_with(function(x) str_remove_all(x, ".fasta|.fa"), everything()) %>% 
  mutate_at("FILE", function(x) str_remove_all (x, ".fasta|.fa")) %>% 
  mutate_at(vars(-any_of("FILE")), function(x) str_remove(x, "INF-")) %>% 
  mutate_at(vars(-any_of("FILE")), 
            function(x) 
              str_replace_all(x, 
                              "(PLOT5)|(PLOT3)|(LNF)|(ASM)|(ALM)|(NIPH)|(NIPHEM) ",
                              NA_character_)) %>%
    mutate_at(vars(-any_of("FILE")), as.factor) %>%
  write_tsv(., args[2]) 


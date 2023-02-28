#!/usr/bin/env Rscript
# calculate number missing loci - 
# filter out isolates where too many loci are missing
# Returns data that can be used to perform hierarchical clustering


# Setup 
library("pacman")
p_load(tidyverse)
# Usage: Rscript <scriptname> <input> <filter> <output> 
args = commandArgs(trailingOnly=TRUE)

# filter: maximum number of missing alleles to authorize
input <- args[1]
maxmissing <- args[2]
output <- args[3]

# TEST 
# input <- "clean_results_alleles.tsv"
# maxmissing <- "NULL"
# output <- "filtered_results_alleles.tsv"

# import cleaned data
df <- read_tsv(input, col_types = cols(.default = "c"))

# nbloci in scheme 
nbloci <- ncol(df) -1
  
# calculates the number of missing loci and output summary 
# computing statistics for number of missing loci per isolate
message("calculates number of missing loci per isolate")

df %>%
  mutate_at(vars(-any_of("FILE")), as.factor) %>%
  rowwise() %>%
  mutate(`missing loci` = sum(is.na(c_across(where(is.factor))))) %>%
  group_by(FILE) %>% 
  mutate(`present loci`= nbloci - `missing loci`) %>%
  mutate(`total loci` = nbloci) %>%
  mutate(`% missing` = `missing loci` / `total loci` *100) %>%
  select(`missing loci`, `% missing`, `present loci`, `total loci`) %>%
  write_tsv(., "statistics_missing_loci.tsv")
  
# filtering out missing loci 
message("filtering data with more than ", maxmissing, " loci missing")

if ( maxmissing == "NULL" ){
  # case where data already filtered
  # have to have "NULL" as imported as string
  df %>%
    write_tsv(., output)  
} else {
  # filter isolates NA_count <= maxmissing
  df %>%
    mutate_at(vars(-any_of("FILE")), as.factor) %>% # ensure correct format
    rowwise() %>%
    mutate(NA_count = sum(is.na(c_across(where(is.factor))))) %>%
    group_by(FILE) %>%
    filter(NA_count <= as.numeric(maxmissing)) %>%
    select(-NA_count) %>%
    write_tsv(., output)  
}

message("if error, please recheck how many loci you decided to allow as missing")
# Concatenate datasets (tsv) that have same headers (ie. for individual chewBBACA runs)
require(optparse) if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse)
require(optparse)

option_list = list(
  make_option("--directory", action="store", 
              default=".", type='character',
              help="Directory that include all the individual results files you want to concatenate. Can include subdirectories"),
  make_option("--output", action="store", 
              default="concatenated.tsv", type='character',
              help="Output path/file name for the concatenated dataset"),
  make_option("--id_pattern", action="store", 
              default="*_alleles.tsv", type='character',
              help="Pattern that allows to uniquely identify files and only files you want to concatenate within --directory."),
  make_option("--clean_pattern", action="store", 
              default="(_assembly.fasta)|(.fasta)", type='character',
              help="Patterns each within () and separated by | to clean FILE (ID name) and headers. order matters!")
              
)

opt = parse_args(OptionParser(option_list=option_list))

# Test 
opt <- list(
  directory = "",
  output = "contactenated.tsv",
  id_pattern = "*_alleles.tsv",
  clean_pattern = "(_assembly.fasta)|(.fasta)"
)

myfiles <- list.files(path=opt$directory, 
                      pattern=opt$id_pattern, 
                      full.names = T, 
                      recursive = T)

dat_tsv <- plyr::ldply(myfiles, read_tsv, col_types = cols(.default = "c"))

dat_tsv <- 
  dat_tsv %>% 
  rename_with(function(x) str_remove_all(x, opt$clean_pattern), everything()) %>%
  mutate_at("FILE", function(x) str_remove_all(x,opt$clean_pattern)) 

write_tsv(dat_tsv, opt$output)


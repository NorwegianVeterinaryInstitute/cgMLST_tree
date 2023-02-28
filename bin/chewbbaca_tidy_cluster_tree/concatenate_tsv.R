# Concatenate datasets (tsv) that have same headers (ie. for individual chewBBACA runs)
require(optparse)
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse)
require(optparse)

# example https://gist.github.com/ericminikel/8428297
# This is config file with defaults

option_list = list(
  make_option("--directory", action="store", 
              default="/mnt/2T/proficiency/listeria/complete_second/chewbbaca/results", type='character',
              help="Directory that include all the individual results files you want to concatenate. Can include subdirectories"),
  make_option("--output", action="store", 
              default="concatenated_alleles.tsv", type='character',
              help="Output path/file name for the concatenated dataset"),
  make_option("--id-pattern", action="store", 
              default="*_alleles.tsv", type='character',
              help="Pattern that allows to uniquely identify files and only files you want to concatenate within --directory."),
  make_option("--clean-pattern", action="store", 
              default="(_assembly.fasta)|(.fasta)", type='character',
              help="Patterns each within () and separated by | to clean FILE (ID name) and headers. order matters!")
              
)

opt = parse_args(OptionParser(option_list=option_list))


# https://datascienceplus.com/how-to-import-multiple-csv-files-simultaneously-in-r-and-create-a-data-frame/
myfiles <- list.files(path=opt$directory, 
                      pattern=opt$`id-pattern`, 
                      full.names = T, 
                      recursive = T)

dat_tsv <- plyr::ldply(myfiles, read_tsv, col_types = cols(.default = "c"))
dat_tsv %>% 
  rename_with(function(x) str_remove_all(x, opt$`clean-pattern`), everything()) %>%
  mutate_at("FILE", function(x) str_remove_all(x,opt$`clean-pattern`)) -> dat_tsv

write_tsv(dat_tsv, opt$output)


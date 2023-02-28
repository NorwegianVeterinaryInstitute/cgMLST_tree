if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, magrittr,  cluster, ape)


# https://bioinformaticsdotca.github.io/GenEpi_2017_module3_lab
# statistics 
statistics_file <- "/mnt/2T/proficiency/listeria/Anses_LSAl_20_07_EURL_Lm_WGS/analyses_given_fastqc/chewBBACA/results/results_20201030T161710/results_statistics.tsv"
statistics <- read_tsv(statistics_file)

# tidy_chewbbaca typing
typing_file <- 
"/mnt/2T/proficiency/listeria/Anses_LSAl_20_07_EURL_Lm_WGS/analyses_given_fastqc/chewBBACA/results/results_20201030T161710/cgMLST_completegenomes/cgMLST.tsv"
# 
typing <- read_tsv(typing_file)
dim(typing)
head(typing)

# FILE  lmo0002.fasta lmo0003.fasta lmo0005.fasta lmo0006.fasta lmo0007.fasta lmo0009.fasta lmo0010.fasta lmo0011.fasta lmo0012.fasta lmo0015.fasta
# <chr>         <dbl> <chr>         <chr>         <chr>         <chr>         <chr>                 <dbl> <chr>         <chr>                 <dbl>
#   1 stai…             2 2             2             4             18            2                         2 2             165                       2
# 2 stai…             2 2             2             4             18            2                         2 2             165                       2
# 3 stai…             1 LNF           PLOT3         LNF           LNF           PLOT3                     1 LNF           PLOT5                     1
# 4 stra…             2 2             2             4             18            2                         2 2             165                       2
# 5 stra…             2 3             2             4             3             3                         4 4             INF-169                   4
# 6 stra…             2 2             11            15            14            9                         8 12            165                       2


# with no conversion
typing_original_file <- 
  "/mnt/2T/proficiency/listeria/Anses_LSAl_20_07_EURL_Lm_WGS/analyses_given_fastqc/chewBBACA/results/results_20201030T161710/results_alleles.tsv"
# 
typing_original <- read_tsv(typing_original_file, col_types = cols(.default = "c")) 
  
dim(typing_original)
head(typing_original)
# FILE  lmo0002.fasta lmo0003.fasta lmo0005.fasta lmo0006.fasta lmo0007.fasta lmo0009.fasta lmo0010.fasta lmo0011.fasta lmo0012.fasta lmo0015.fasta
# <chr>         <dbl> <chr>         <chr>         <chr>         <chr>         <chr>                 <dbl> <chr>         <chr>                 <dbl>
#   1 stai…             2 2             2             4             18            2                         2 2             165                       2
# 2 stai…             2 2             2             4             18            2                         2 2             165                       2
# 3 stai…             1 LNF           PLOT3         LNF           LNF           PLOT3                     1 LNF           PLOT5                     1
# 4 stra…             2 2             2             4             18            2                         2 2             165                       2
# 5 stra…             2 3             2             4             3             3                         4 4             INF-169                   4
# 6 stra…             2 2             11            15            14            9                         8 12            165                       2

# presence abscence
PA_file <- "/mnt/2T/proficiency/listeria/Anses_LSAl_20_07_EURL_Lm_WGS/analyses_given_fastqc/chewBBACA/results/results_20201030T161710/cgMLST_completegenomes/Presence_Absence.tsv"
PA <- read_tsv(PA_file, col_types = cols(.default = "c"), na = c("0", "NA")) %>% 
  column_to_rownames("FILE") 
dim(PA)
View(PA)
# So will work on that import proprely
typing <- read_tsv(typing_original_file, col_types = cols(.default = "c")) %>% 
  rename_with(function(x) str_remove(x, ".fasta"), everything()) %>% 
  mutate_at("FILE", function(x) str_remove(x, ".fasta")) 

# now we need to deal with the special types of comments

# NIPH Loci must be removed from analysis
# NIPHEM Loci must be removed from analysis
# ALM alleles need to be removed from analysis - or scheme updated and analysis redone -> eventually remove those loci - loci with larger allelic size variation
# ASM alleles need to be removed from analysis - or scheme updated and analysis redone - eventually remove those loci - loci with larger allelic size variation
# PLOT5 or PLOT3 -> removed allele ... as we are not sure its complete because could be artifact 
# LNF -> allele as NA 
# INF-XX INF text must be removed and scheme must be updated grep("INF", typing) to locate
# EXC loci - nothing to do - locate  with grep("EXC", typing)



# we need to discard samples that are not validating the minimum number of required alleles in typing - no point to compute distances
# note on phyloviz online version - data are imported AS IS ... and tag after INF is removed ! 
grep("INF", typing)
grep("NIPH", typing)
grep("NIPHEM", typing)
typing %>% mutate_all(function(x) str_remove(x, "INF-")) %>% 
  mutate_all(function(x) str_replace_all(x, "(PLOT5)|(PLOT3)|(LNF)|(ASM)|(ALM)|(NIPH)|(NIPHEM) ", NA_character_)) %>% 
  mutate_at(vars(2:1749), as.factor) -> tidy_typing


# distance have to be categorical variables !! 
# library daisy -> testing the distances
test_dist <- data.frame("FILE" = c("A","B","C"), x = c(1,NA,2), y = c(2,1,2), z = c(1,2,3))
test_dist
test_dist %>% column_to_rownames("FILE") %>%
  mutate_all(as.factor) -> test_dist_fact

test_dist %>% column_to_rownames("FILE") %>%
  mutate_all(as.numeric) -> test_dist_numeric

daisy(test_dist_fact, metric = "gower")
daisy(test_dist_numeric, metric = "gower")


# we need to filter rows that are not sufficent data -> how many was it?
# First count nb of NA : https://sebastiansauer.github.io/sum-isna/
dim(tidy_typing)
tidy_typing %>% select(2:1749) %>%
  is.na %>%
  rowSums

# NA_count <- 
# cbind (tidy_typing$"FILE", apply(tidy_typing, MARGIN = 1, FUN = function(x) length(x[is.na(x)])))
# names(NA_count) <- c("FILE", "NA_count")
# NA_count

# still would be better to do it as ... tidyverse style  
# https://dplyr.tidyverse.org/articles/rowwise.html
dim(tidy_typing)
tidy_typing %>% rowwise() %>%
  mutate(NA_count = sum(is.na(c_across(2:1749)))) %>%
  select(FILE, NA_count) %>%
  View(.)

tidy_typing %>% rowwise() %>%
  mutate(NA_count = sum(is.na(c_across(2:1749)))) -> tidy_typing_NA_count

# now we can filter those that do not mean a certain threshold of missing values
max_missing <- 10
tidy_typing_NA_count %>% filter(NA_count < 10) %>%
  select(-NA_count) %>%
  mutate_at(vars(2:1749), as.factor) %>%
  column_to_rownames("FILE") -> tidy_typing_distance_ready

dim(tidy_typing_distance_ready)
str(tidy_typing_distance_ready)[1:10]


levels(tidy_typing_distance_ready$lmo0012)
# ok this is good the levels are not included in factor 

dissimilarity_matrix <- daisy(tidy_typing_distance_ready, metric = "gower")

# Warnings before typing is identical between strains
dissimilarity_matrix

# now we can do the hierarchical clustering with single linkage, and the tree (as in Haukons)
# https://github.com/hkaspersen/distanceR/blob/master/R/calc_tree.R
single_tree <- ape::as.phylo(hclust(dissimilarity_matrix, method = "single"))
plot(single_tree) # fast check  -> ok
single_tree_file <- "/mnt/2T/proficiency/listeria/Anses_LSAl_20_07_EURL_Lm_WGS/analyses_given_fastqc/chewBBACA/results/results_20201030T161710/single_linkage.tree"
write.tree(single_tree, file = single_tree_file)


# neighbor joining tree

nj_tree <- ape::nj(dissimilarity_matrix)
plot(nj_tree)
nj_tree_file <-  "/mnt/2T/proficiency/listeria/Anses_LSAl_20_07_EURL_Lm_WGS/analyses_given_fastqc/chewBBACA/results/results_20201030T161710/nj.tree"
write.tree(nj_tree, file = nj_tree_file)

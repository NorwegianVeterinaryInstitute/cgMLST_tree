if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, magrittr, cluster, ape, cultevo)

# inspired by Haakon ttps://github.com/hkaspersen/distanceR/blob/master/R/calc_tree.R

tidy_cgMLST <- function(directory, input, output, assembly_extension) {
  #' Import and tidy cgMLST typing results from chewBBACA
  #' PLOT5, PLOT3, LNF, ASM, ALM, NIPH, NIPHEM will be considered as missing alleles
  #' INF-xx representing new alleles will be replaced by xx.
  #' Consider updating your scheme and re-runing chewBBACA analyses if you have INF
  #' @param directory chewBBACA typing directory
  #' @param input chewBBACA typing results file name. Sample name col has to be named "FILE"
  #' @param output file name of the tidied typing table .tsv
  #' 
  #' @author Eve Zeyl Fiskebeck, \email{evfi@@vetinst.no}
  #'  
  #' @export
  #' @import tidyverse
  #' @import magrittr
  #'  
  message("tidying with function: tidy_cgMLST")
  typing_file <- paste(directory, input, sep ="/")
  typing <- read_tsv(typing_file, col_types = cols(.default = "c")) %>% 
    rename_with(function(x) str_remove(x, assembly_extension), everything()) %>% 
    mutate_at("FILE", function(x) str_remove(x, assembly_extension)) 
  
  tidy_typing <- typing %>% 
    mutate_at(vars(-any_of("FILE")), function(x) str_remove(x, "INF-")) %>% 
    mutate_at(vars(-any_of("FILE")), function(x) str_replace_all(x, 
                                                                 "(PLOT5)|(PLOT3)|(LNF)|(ASM)|(ALM)|(NIPH)|(NIPHEM) ",
                                                                 NA_character_)) %>%
    mutate_at(vars(-any_of("FILE")), as.factor)
  
  tidyied_file <- paste(directory, output, sep ="/")
  write_tsv(tidy_typing, tidyied_file) 
  return(tidy_typing)
}

filter_missing <- function(tidy_typing, max_missing) {
  #' Filter out isolates with typed with missing data over a given threshold 
  #' @param tidy_typing chewBBACA tidied typing object
  #' @param max_missing maximum number of missing alleles to be allowed
  #' @returns tidyied_typing object, isolates with too many missing alleles have been filtered out
  #' 
  #' @author Eve Zeyl Fiskebeck, \email{evfi@@vetinst.no}
  #'  
  #' @export
  #' @import tidyverse
  #' @import magrittr
  #'  
  #'  
  message("filtering missing data with function: filter_missing")
  tidy_typing_NA_count <- tidy_typing %>% 
    mutate_at(vars(-any_of("FILE")), as.factor) %>% # ensure correct format
    rowwise() %>%
    mutate(NA_count = sum(is.na(c_across(where(is.factor))))) %>%
    group_by(FILE) %>% 
    filter(NA_count < max_missing) %>%
    select(-NA_count) 
  
  return(tidy_typing_NA_count)
}

calculate_missing <- function (tidy_typing_df, directory = directory, outname = "count_missing_loci.tsv") {
  #' Return and write the count of missing loci, present loci and total loci from cgMLST tidy data 
  #' @return data frame with count of missing alleles, non missing and total number of loci
  #' @param tidy_typing_df a tidied cgMLST typing - "FILE" must be as given as colname
  #' @param directory the directory for output (same as input)
  #' @param outname where to write: output path/name the count missing file
  #'  
  #' @author Eve Zeyl Fiskebeck, \email{evfi@@vetinst.no}
  #'  
  #' @export
  #' @import tidyverse

  message("calculating missing data with function:calculate_missing ")
  nbloci <- ncol(tidy_typing_df) -1
  
  # note: could have been merged with above
  # ensure that is factor but should be at origin - never know
  df_missing <- tidy_typing_df %>% 
    mutate_at(vars(-any_of("FILE")), as.factor) %>%
    rowwise() %>%
    mutate(missing_loci = sum(is.na(c_across(where(is.factor))))) %>%
    group_by(FILE) %>% 
    mutate(present_loci = nbloci - missing_loci) %>%
    mutate(total_loci = nbloci) %>%
    mutate("% missing" = missing_loci / total_loci *100) %>%
    select(missing_loci, "% missing", present_loci, total_loci)
  
  out_file <- paste(directory, outname, sep = "/")
  write_tsv(df_missing, out_file)
  
  return(df_missing)
} 


compute_dissimilarity_matrix <- function(filtered_missing_typing, outdir = opt$d, outname = "dissimilarity_matrix.tsv") {
  #' Computes the dissimilarity matrix and write it out in given output folder  
  #' @param filtered_missing_typing tidied and filtered cgMLST typing
  #' @param outdir output folder ofr the matrix
  #' @param outname name of the output file 
  #' @returns dissimilarity matrix, write tsv matrix file in chewBBACA results directory 
  #' 
  #' @author Eve Zeyl Fiskebeck, \email{evfi@@vetinst.no}
  #'  
  #' @export
  #' @import cluster
  #' 
  message("computing dissimilarity matrix with function: compute_dissimilarity_matrix")
  df <- filtered_missing_typing %>% 
    column_to_rownames("FILE")
  
  dissimilarity <- daisy(df, metric = "gower")
  #dissimilarity_matrix <- as.matrix(dissimilarity)
  matrix_file <- paste(outdir, outname, sep = "/")
  
  write.table(as.data.frame(as.matrix(dissimilarity), make.names = T),
              matrix_file, 
              sep = "\t", 
              row.names = T,
              col.names = NA)
  return(dissimilarity)
}

calculate_hamming <- function (tidy_typing_df, directory, outname = "hamming_distance.tsv") {
  #' Return and write the hamming distance from a tidied cgMLST typing dataframe 
  #' Note: hamming distance: missing alleles are not counted as distance in pairwise comparison
  #' @return data frame with hamming distances
  #' @param tidy_typing_df a tydied cgMLST typing - "FILE" must be as given as colname
  #' @directory chewbcacca dir for output/input
  #' @param outname where to write: output path/name the hamming distance tsv file
  #'  
  #' @author Eve Zeyl Fiskebeck, \email{evfi@@vetinst.no}
  #'  
  #' @export
  #' @import cultevo
  #' @import tidyverse
  
  # prepare format to be sure working as should
  message("calculating hamming distances with function: calculate_hamming")
  df <- tidy_typing_df %>%
    mutate_at(vars(-any_of("FILE")), as.factor)
  
  df_names <- df$"FILE" 

  
  # compute distance and transform to symetric matrix and to dataframe  
  df <- df %>%  column_to_rownames("FILE")
  df <- as.data.frame(as.matrix(hammingdists(df))) %>%
    rownames_to_column(var = "FILE") 
  
  
  # put the names in correct format 
  names(df) <- c("FILE", df_names)
  df$"FILE" <- df_names
  
  # write it
  outfile <- paste(directory, outname, sep = "/")
  write_tsv(df, outfile)
  
  return(df)
}


# NB: if returns Warning messages: 1: In min(x) : no non-missing arguments to min; returning Inf
# means identical typing 

do_clustering <- function(dissimilarity_matrix, method, outdir, outtree) {
  #' Do clustering from dissimilarity matrix. 
  #' Either with hierarchical clustering - single linkage or with
  #' Neighbor joing 
  #' Write the tree in newick format in output folder 
  #' @return phylo-object
  #' @param method "single" for single linkage hierarchical clustering or "nj" for neighbor joining tree
  #' @param outdir output folder for the tree
  #' @param outtree name of the output tree file eg mytree.tree 
  #' @param outname name of the output for the dissimilariy matrix 
  #'  
  #' @author Eve Zeyl Fiskebeck, \email{evfi@@vetinst.no}
  #'  
  #' @export
  #' @import cluster
  #' @import ape 
  
  message("hierarchical clustering with function: do_clustering")
  if (method == "single"){ 
    tree <- ape::as.phylo(hclust(dissimilarity_matrix, method))  
    }
  else if (method == "nj") {
    tree <- ape::nj(dissimilarity_matrix)
  }

  tree_file <- paste(outdir, outtree, sep = "/") 
  write.tree(tree, file = tree_file)
  return(tree)
}

# to call the function with R script 
wrapper_call <- function(directory = opt$directory,
                         input = opt$input,
                         tidy_output = opt$tidy_output,
                         clustering = opt$clustering_method, 
                         tree = opt$tree, 
                         assembly_extension = opt$assembly_extension,
                         max_missing = opt$max_missing, 
                         out_dissimilarity = "dissimilarity_matrix.tsv",
                         out_missing = "count_missing_loci.tsv",
                         out_hamming = "hamming_distance.tsv") {
  
  #' wrapper to run all the steps at once
  mytidy <- tidy_cgMLST(directory, input, tidy_output, assembly_extension)
  calculate_missing(mytidy, directory, out_missing)
  myfiltered <- filter_missing(mytidy, max_missing)
  calculate_hamming(myfiltered, directory, out_hamming)
  mydissimilarity <- compute_dissimilarity_matrix(myfiltered, directory, outname = out_dissimilarity)
  do_clustering(mydissimilarity, clustering, directory, tree) 
}





df <- read_tsv("tidy_cgMLST.tsv") %>%
  mutate_at(vars(-any_of("FILE")), as.factor) %>%
  column_to_rownames("FILE")

df_names <- colnames(df)
df_names

head(df)
View(df)

ham_df <- hammingdists(df) # seems to work ! 
ham_df


test <- as.data.frame(t(data.frame(A = c(1,2,3), B = c(1, NA, 2), C = c(NA, 2, 3)))) %>% 
  rownames_to_column("FILE") %>%
  mutate_at(vars(-any_of("FILE")), as.factor)
test_names <- test$"FILE"
test2 <- test %>%
  column_to_rownames("FILE")

test2 <- as.data.frame(as.matrix(hammingdists(test2))) %>%
  rownames_to_column(var = "FILE") 
names(test2) <- c("FILE", test_names)
test2$"FILE" <- test_names
test2


#write_tsv(test3, "hamming_distances.txt")

## write.matrix(test2, "hamming_distances.txt", sep = "\t")

################################################################################

calculate_hamming <- function (tidy_typing_df, outname = "hamning_distance.tsv") {
  
  
  # prepare format to be sure working as should
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
  write_tsv(df, outname)
  
  return(df)
}

# testing 
test <- as.data.frame(t(data.frame(A = c(1,2,3), B = c(1, NA, 2), C = c(NA, 2, 3)))) %>%
  rownames_to_column("FILE")
calculate_hamming(test)

#######################################################################################
# we need to get the stats for each pairs:

## we can get the matrix as list format -> this will give us all the pairs combinations
## then we can compute for each sample how many NA 
## and for each pairs how many are comparable
## remeber to use the total for output as sanity check 

# for pairs 
# nb loci 
ncol(df)

#################################################################################
## getting missing statistics 
test <- as.data.frame(t(data.frame(A = c(1,2,3), B = c(1, NA, 2), C = c(NA, 2, 3)))) %>%
  rownames_to_column("FILE") %>%
  mutate_at(vars(-any_of("FILE")), as.factor)

# str(test)
# 
# 
# nbloci <- ncol(test) -1
# nbloci
# 
# 
# # has to group_by otherwise the rowwise is messing the grouping
# test %>% 
#   rowwise() %>%
#   mutate(missing_loci = sum(is.na(c_across(where(is.factor))))) %>%
#   group_by(FILE) %>% 
#   mutate(present_loci = nbloci - missing_loci) %>%
#   mutate(total_loci = nbloci) %>%
#   mutate("% missing" = present_loci / total_loci *100) %>%
#   select(missing_loci, "% missing", present_loci, total_loci) %>% 
#   
#   
#   mutate(number_loci_present = - nbloci)
#   
# select(NA_count)
# 
# tidy_typing_NA_count
# 
#   select(NA_count)
# tidy_typing_NA_count

calculate_missing(test)
mydf <- read_tsv("tidy_cgMLST.tsv") %>%
  mutate_at(vars(-any_of("FILE")), as.factor) 

calculate_missing(mydf)
filter_missing(mydf, 10) %>% View(.)

calculate_hamming(mydf) %>% View(.)

################################################################################
# BETTER TEST hamming - recheck  that I am doing right with factors 
test <- as.data.frame(t(data.frame(A = c(1,4,3,6), B = c(1, NA, 2, NA), 
                                   C = c(6,2,3,6), D = c(2, NA, 4, NA), 
                                   E = c(NA,2,3,1)))) %>%
  rownames_to_column("FILE") %>%
  mutate_at(vars(-any_of("FILE")), as.factor)
calculate_hamming(test)
calculate_missing(test)

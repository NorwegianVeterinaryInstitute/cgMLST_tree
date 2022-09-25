# testing 
# opt <- list(
#   p = "cgMLST_Listeria_monocytogenes_Pasteur", 
#   to = "evfi_tidy_cgMLST.tsv",
#   d = "/mnt/2T/proficiency/listeria/Anses_LSAl_20_07_EURL_Lm_WGS/analyses_given_fastqc/chewBBACA/results/results_20201030T161710", 
#   i = "results_alleles.tsv",
#   s = "", 
#   c = "single",
#   t = "cluster.tree",
#   ae = ".fasta",
#   mm = 10
# )


# This is now working 



df <- tidy_cgMLST (opt$directory, opt$input, opt$tree, opt$assembly_extension)
df_dist_ready <- filter_missing(df, opt$max_missing)
mydissimilarity <- compute_dissimilarity_matrix(df_dist_ready, opt$directory)
mysingletree <- do_clustering (mydissimilarity, opt$clustering_method, opt$directory, opt$tree)
mynj <- do_clustering (mydissimilarity, "nj", opt$directory, "nj_cluster.tree")

# This option we can remove as long as we do not look for cgMLST profiles
# make_option(c("-db", "--database"), action="store", 
#             default="",
#             type='character',
#             help="path/file of the typing profile database"),
# make_option(c("-p", "--profiles_table"), action="store", 
#             default="cgMLST_Listeria_monocytogenes_Pasteur",
#             type='character',
#             help="Name of the profile table to use in the MySql database"),

# thest the whole function





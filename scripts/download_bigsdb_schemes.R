# Author Eve Zeyl Fiskebeck
# evfi@vetinst.np
# Date review: 2022-11-02

# Packages setup 
if (!require("pacman")) {install.packages("pacman", dependencies = T)}
if (!require("httr")) {install.packages("httr", dependencies = T) }
if (!require("jsonlite")) {install.packages("jsonlite", dependencies = T)}
p_load(httr, jsonlite, tidyverse, log4r)
################################################################################
# USER INFORMATION - CHOICES ----
## User defines outdir 
outdir <- readline(prompt ="Please enter output directory path: eg. ./test OR mypath OR .  ")

## API entrance level 
api <- fromJSON("https://bigsdb.pasteur.fr/api") 

## User defines species of interest 
genus_id <- menu(api$name, title = "Please chose the organism you want to download data from:")

## User defines choice of database 
data_base_id <- menu(api$databases[[genus_id]]$name, 
                  title = "Please chose the database you want to download data from. 
                  NB: Downloading schemes is done with x_seq_def: ")

## get url of choosen database 
db_url <- api$databases[[genus_id]]$href[[data_base_id]]

## get the available schemes for the chosen database
schemesdb_url <- fromJSON(db_url)$schemes
schemesdb <- fromJSON(schemesdb_url)

## User choose scheme 
chosen_scheme_id <- menu(schemesdb$schemes$description, 
                         title = "Please chose the desired scheme: ")

scheme_name <- schemesdb$schemes$description[chosen_scheme_id]

## get the scheme 
scheme_url <- schemesdb$schemes$scheme[chosen_scheme_id]
scheme <- fromJSON(scheme_url)

################################################################################
# CREATING LOG FOR DOWNLOAD PROCESS ----
# only partial
# https://community.rstudio.com/t/creating-log-files-in-r/71541/2
my_logfile <- paste(outdir, sprintf("%s_download.log", scheme_name), sep="/")
my_console_appender = console_appender(layout = default_log_layout())
my_file_appender = file_appender(my_logfile, append = TRUE, 
                                 layout = default_log_layout())
my_logger <- log4r::logger(threshold = "DEBUG", 
                           appenders= list(my_console_appender,my_file_appender))

log4r_info <- function(info_message) {
  log4r::info(my_logger, sprintf("\n%s\n", info_message))
}

# log4r_error <- function() {
#   log4r::error(my_logger, "Error_message")
# }
# 
# log4r_debug <- function() {
#   log4r::debug(my_logger, "Debug_message")
# }


################################################################################
# get the allelic profiles
m <- sprintf("Starting scheme download.\n
                Date download: %s\n
                Download of %s BIGSDB %s scheme.\n" , 
                Sys.time(), 
                api$name[genus_id], 
                scheme_name)
log4r_info(m)

m <- sprintf("Downloading scheme profiles in file %s_profiles.csv\n", scheme_name)
log4r_info(m)

curl_download(scheme$profiles_csv, 
              paste(outdir, "/", scheme_name, "_profiles.csv", sep = ""))

# creating table for downloading alleles of the scheme 
loci_url <- scheme$loci
download_df <- 
  tibble("loci_url" = loci_url) %>%
  mutate(fasta_url = paste(loci_url, "alleles_fasta", sep = "/")) %>%
  mutate(to_file = str_remove_all(loci_url, "^.*/")) %>%
  mutate(to_file = paste0(to_file, ".fasta"))

# Downloading the scheme
m <- sprintf("Downloading the alleles of the %s scheme", scheme_name)
log4r_info(m)

mapply(curl_download, 
       download_df$fasta_url, 
       paste(outdir, download_df$to_file, sep = "/"))

if (length(loci_url) == length(list.files(path = outdir, pattern = ".fasta"))){
  log4r_info("Download complete")
}



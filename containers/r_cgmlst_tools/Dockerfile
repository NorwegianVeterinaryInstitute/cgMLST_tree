# syntax=docker/dockerfile:1
FROM debian:11.5
LABEL OS="debian:bullseye" \
    pipeline="cgMLST_tree" \
    github="https://github.com/NorwegianVeterinaryInstitute/cgMLST_tree" \
    description="R packages necessary to run the pipeline scripts" \
    maintainer="evezeyl@gmail.com"

# install app dependencies
RUN apt-get update && apt-get install -y build-essential 
RUN apt-get -y install dirmngr gnupg apt-transport-https ca-certificates software-properties-common

# R Install - and packages 
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian bullseye-cran40/'
RUN apt-get update && apt-get -y install r-base r-base-dev  \ 
    r-cran-ape \
    r-cran-cairodevice r-cran-cairo \
    r-cran-cluster \ 
    r-cran-formattable \
    r-cran-ggplot2 \
    r-cran-tidyverse \
    r-cran-patchwork \
    r-cran-plotly \
    r-cran-viridis 

# In case - REMOVE if not needed
RUN R --slave -e 'install.packages("pacman", dependencies = TRUE)'
RUN R --slave -e 'library(pacman); p_load(knitr, kableExtra, cultevo)' 
RUN R --slave -e 'install.packages("BiocManager", dependencies = TRUE); BiocManager::install("ggtree"); BiocManager::install("treeio")' 

# Install ps to allow nextflow to collect task metrics
RUN apt-get update && apt-get -y install procps




# Environments
ENV LC_ALL=C
ENV PATH="$PATH:/usr/bin"
ENV R_LIBS_USER="/usr/local/lib/R/site-library:/usr/lib/R/site-library:/usr/lib/R/library"    

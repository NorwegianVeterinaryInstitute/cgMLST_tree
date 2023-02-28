# syntax=docker/dockerfile:1
FROM debian:11.5
LABEL OS="debian:bullseye" \
    pipeline="cgMLST_tree" \
    github="https://github.com/NorwegianVeterinaryInstitute/cgMLST_tree" \
    description="R packages necessary to run the pipeline scripts" \
    maintainer="evezeyl@gmail.com"

# install app dependencies
RUN apt-get update && apt-get install -y apt-utils build-essential zlib1g-dev \
            libncurses5-dev libgdbm-dev libnss3-dev libssl-dev \
            libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
RUN apt-get -y install dirmngr gnupg apt-transport-https ca-certificates software-properties-common
RUN apt-get -y install python3 python3-pip

# Install BLAST - PRODIGAL - MAFFT
RUN apt-get update && apt-get -y install ncbi-blast+ prodigal mafft

# ChewBBACA Install - and packages 
RUN pip3 install chewbbaca

# Install ps to allow nextflow to collect task metrics
RUN apt-get update && apt-get -y install procps

# Environments
ENV LC_ALL=C
ENV PATH="$PATH:/usr/bin:/usr/local/bin"    

# cgMLST_tree

! This is a work in progress (freetime) and work
? integrate with Alppaca (discussed with Håkon)

version: 1.0.0 - functionning locally


- Cleaning cgMLST data labels from chewBBACA
- filters out isolates with n missing loci (data quality filtering). n is provided by user
- Computes hamming distance
- Computes dissimilarity matrix
- Produces a tree (NJ or UPGMA) based on the hierarchical clustering

Written in: Nextflow and R

Origin:
- rewritting scripts that were used for "listeria profficiency testing"

rewritting of script to create hierarchical clustering - NJ or Single trees from chewBBACA cgMLST

Organisation:
Folders:
- `bin`: contains the R scripts necessary to perform the analyses
- `scripts` : helper scripts eg. to download cgMLST scheme from BIGSDB (interactive choice)
- `modules`: contains nextflow modules
- `worflows`: contains nextflow workflows

- `main.nf`: the pipeline script
- `fedora.config.nf`: the configuration file (system config parameters) according to the system that I am using (for now) AND profile local  
    - contains paths specific for my system : you can edit those and adapt to your system
    - contains `outdir` parameter (per default - you can change that and set it in `user.config.nf`)
    - adjust the parameters according to installation of the pipeline

- `user.config.nf` - defines parameters
    raw_results = path - raw results from cgMLST typing with chewBBACA ex: path/results_alleles_test.tsv"
    maxmissing = "NULL" or max number of missing loci that are allowed
    method =  "nj" or "single" for the hierarchical clustering
    outdir = path directory where the results will be deposited (priority over the system config parameters)

NOTES: until now only done to functionne locally

Usage:
```bash
# java version
# Usage nextflow
FOLDER="$HOME/Documents/onedrive_sync/ONE_OBSIDIAN/GITS_WORK/cgMLST_tree"
NFSCRIPT="${FOLDER}/main.nf"
USERCONFIG="${FOLDER}/user.config.nf" # specific user parameters
CONFIG="${FOLDER}/fedora.config.nf" # processes and profiles and specific pc/cluster

nextflow run ${NFSCRIPT} -c ${CONFIG} -c ${USERCONFIG} -profile local
```

# Scripts usage
## Download schemes
`Rscript download_bigsdb_schemes.R` you will be asked a serie of questions for
downloading scheme: download directory, genus, scheme.
Automatically creates a download log in the download directory

- [ ] create image ?
[saga user how to use with R](https://documentation.sigma2.no/software/userinstallsw/R.html)

# Requirements
- nextflow : (DLS2 activated)
    - nextflowVersion = "22.04.5"

-------------------
- R: packages
    - pacman
    - tidyverse
    - cultevo (compute hamming distances)
    - cluster (computing dissimilarity matrix)
    - ape
    - ggtree
    - treeio
    - ggplot2
    - Cairo
    - prettydoc
OR
-docker/singularity (image where R packages are integrated)
    - dockerfile for image build is provided in `containers/r_cgmlst_tools`
    or can be pulled from dockerhub: `evezeyl/r_cgmlst_tools:latest`

-------------------

singularity shell /home/vi2067/Documents/NF_LIBRARY/evezeyl-r_cgmlst_tools.img

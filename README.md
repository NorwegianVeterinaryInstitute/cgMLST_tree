# cgMLST_tree

version: 1.0.0 - functionning locally 


- Cleaning cgMLST data labels from chewBBACA 
- filters out isolates with n missing loci (data quality filtering). n is provided by user 
- Computes hamming distance
- Computes dissimilarity matrix
- Produces a tree (NJ or UPGMA) based on the hierarchical clustering

Written in: Nextflow and R 

Origin: 
- rewritting scripts that were used for "listeria profficiency testing" 

rewritting of script to create hierarchical clustering - NJ or UPGMA trees from chewBBACA cgMLST clustering

Organisation: 
Folders: 
- `bin`: contains the R scripts necessary to perform the analyses
- `modules`: contains nextflow modules
- `worflows`: contains nextflow workflows 

- `main.nf`: the pipeline script 
- `fedora.config.nf`: the configuration file according to the system that I am using (for now) AND profile local  
    - contains paths specific for my system : you can edit those and adapt to your system
    - contains `outdir` parameter (per default - you can change that and set it in `user.config.nf`)

- `user.config.nf`

Usage: 
```bash 
# java version 
# Running nextflow 
FOLDER="$HOME/Documents/onedrive_sync/ONE_OBSIDIAN/GITS_WORK/cgMLST_tree"
NFSCRIPT="${FOLDER}/main.nf"
USERCONFIG="${FOLDER}/user.config.nf" # specific user parameters
CONFIG="${FOLDER}/fedora.config.nf" # processes and profiles and specific pc/cluster 

nextflow run ${NFSCRIPT} -c ${CONFIG} -c ${USERCONFIG} -profile local 

```
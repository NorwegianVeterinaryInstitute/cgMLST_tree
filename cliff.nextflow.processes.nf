// nextflow processes definition
process {
    withName: CHEWBBACA {
        conda '/home/evezeyl/anaconda3/envs/chewbbaca'
        //container = "evezeyl/r_cgmlst_tools"
        //cpus = 2
    }
    
	withName: CLEAN_LABELS {
        container = "evezeyl/r_cgmlst_tools"
        cpus = 2
    }
	
	withName: FILTER_MISSING {
        container = "evezeyl/r_cgmlst_tools"
        cpus = 2
    }

	withName: HAMMING_DISTANCE {
        container = "evezeyl/r_cgmlst_tools"
        cpus = 4
    }

	withName: DISSIMILARITY_MATRIX {
        container = "evezeyl/r_cgmlst_tools"
        cpus = 2
    }

	withName: CLUSTERING {
        container = "evezeyl/r_cgmlst_tools"
        cpus = 2
    }

    withName: TREE_PLOT {
        container = "evezeyl/r_cgmlst_tools"
        cpus = 2
    }   
}
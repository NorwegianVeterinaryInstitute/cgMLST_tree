// Tested with nextflow version
// nextflowVersion = "22.04.5"

//Fedora specific variables
//this is to avoid contant sync
projectDir="$HOME/Documents/onedrive_sync/ONE_OBSIDIAN/GITS_WORK/cgMLST_tree"
workDir = "$HOME/Documents/NF_WORK/cgMLST"
launchDir="$HOME/Documents/NF_TEST/cgMLST"
singularity.libraryDir="$HOME/Documents/NF_LIBRARY" 
singularity.cacheDir="$HOME/Documents/NF_LIBRARY" 

// parameters (the other above need to find if better way)
params {
	// locations pipeline
	module_dir="$projectDir/modules"
	workflow_dir="$projectDir/workflows"
	script_dir="$projectDir/bin"

	// outdir for testing
	outdir="$launchDir/results"

	// logs
	logsdir="$launchDir/logs"

	// reports 
    reportdir = "$launchDir/nf_reports"
}

//process definitions

process {
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


// environment variables
// https://www.nextflow.io/docs/latest/config.html#config-variables
/*
env {
	NXF_VER="22.04.5"
	NXF_HOME="$HOME/.nextflow"
	// those do not appear to be exported
	NXF_WORK="$HOME/Documents/TEST/cgMLST_tree_work"
	
	// Default 
	NXF_PARAMS_FILE="$HOME/Documents/onedrive_sync/ONE_OBSIDIAN/GITS_WORK/cgMLST_tree/user.config.nf"

	// SOFTWARE 
	NXF_SINGULARITY_LIBRARYDIR="$HOME/Documents/TEST/cgMLST_tree/library" 
	NXF_SINGULARITY_CACHEDIR="$HOME/Documents/TEST/cgMLST_tree/library" 
}
*/

// Profiles
profiles {
	local {
		singularity.enabled = true
		singularity.autoMounts = true
		process {
			executor	 	= 'local'
			errorStrategy		= 'retry'
			maxRetries		= 1
			time			= {8.h * task.attempt}
			cpus			= 4
		}
	}
}

report {
    enabled = true
    file = "$params.reportdir/nextflow_report.html"
}

/*
timeline {
    enabled = true
    file = "$params.reportdir/nextflow_timeline.html"
}

dag {
    enabled = true
    file = "$params.reportdir/nextflow_flowchart.html"
}
*/
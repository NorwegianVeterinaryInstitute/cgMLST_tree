// Tested with nextflow version
// nextflowVersion = "22.04.5"

//Fedora specific variables
//this is to avoid contant sync
launchDir="$HOME/Documents/TEST/cgMLST_tree"
projectDir="$HOME/Documents/onedrive_sync/ONE_OBSIDIAN/GITS_WORK/cgMLST_tree"


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
  /* 
    withName: CLEAN_LABELS {
        container = ""
        cpus = 2
    }
	*/

    
}
// environment variables
// https://www.nextflow.io/docs/latest/config.html#config-variables
env {
	// NF config 
	NXF_VER="22.04.5"
	NXF_HOME="$HOME/.nextflow"
	// those do not appear to be exported
	NXF_WORK="$HOME/Documents/TEST/cgMLST_tree_work"
	
	// Default 
	NXF_PARAMS_FILE="$HOME/Documents/onedrive_sync/ONE_OBSIDIAN/GITS_WORK/cgMLST_tree/user.config.nf"

	// SOFTWARE 
	NXF_SINGULARITY_LIBRARYDIR="$HOME/Documents/onedrive_sync/ONE_OBSIDIAN/Projects/SAV/SAV_amplicon_seq/article/nextflow/library" 
	NXF_SINGULARITY_CACHEDIR="$HOME/Documents/onedrive_sync/ONE_OBSIDIAN/Projects/SAV/SAV_amplicon_seq/article/nextflow/library" 
	
	//NXF_CONDA_CACHEDIR
	
}

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
// cliff and fedora local profiles
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

/*
report {
    enabled = true
    file = "$params.reportdir/nextflow_report.html"
}
*/



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

// environment variables - SHOULD TAKE time define locally 
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
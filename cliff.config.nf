// Tested with nextflow version
// nextflowVersion = "22.04.5"

//Fedora specific variables
//this is to avoid contant sync
projectDir="/mnt/2T/Insync/ONEDRIVE/ONE_OBSIDIAN/GITS_WORK/cgMLST_tree"
workDir = "/mnt/2T/NF_WORK/cgMLST"
launchDir="/mnt/2T/NF_TEST/cgMLST"
singularity.libraryDir="/mnt/2T/NF_LIBRARY" 
singularity.cacheDir="/mnt/2T/NF_LIBRARY" 

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

// INCLUDE CONFIGS  
// Local profile 
includeConfig './local_profile.nf' 
// include specific cgMLST processes
includeConfig './nextflow.processes.nf' 



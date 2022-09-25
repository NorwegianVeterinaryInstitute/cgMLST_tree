// cgMLST_tree pipeline
// wrapping cgMLST chewBBACA results and creating a hierarchical clustering NJ or UPGMA tree 

log.info "============================================================="
log.info " cgMLST tree Pipeline                                        "
log.info " Version: 1.0.0                                              "
log.info "============================================================="
log.info " Run track: NA                                               "
log.info " Work directory: $workDir                                    "
log.info "=============================================================".stripIndent()

//Activate dsl2
nextflow.enable.dsl=2

// Define workflows
include { MAIN_WORKFLOW } from "${params.workflow_dir}/MAIN_WORKFLOW.nf"
workflow {
    /*
	if (params.track == "all") {
		MAIN_WORKFLOW()
	}
    */

    MAIN_WORKFLOW()
}

workflow.onComplete {
	log.info "".center(60, "=")
	log.info "chewBBACA tree pipeline Complete!".center(60)
	log.info "Output directory: $params.outdir".center(60)
	log.info "Duration: $workflow.duration".center(60)
	log.info "Command line: $workflow.commandLine".center(60)
	log.info "Nextflow version: $workflow.nextflow.version".center(60)
	log.info "".center(60, "=")
}


workflow.onError {
	println "Pipeline execution stopped with the following message: ${workflow.errorMessage}".center(60, "=")
}

// Activate dsl2
// Simplifed from Håkon
nextflow.enable.dsl=2

// Define workflows
include { PROFICIENCY_WORKFLOW } from ".workflows/proficiency.nf"

workflow.onComplete {
	log.info "".center(74, "=")
	log.info "Pipeline!".center(74)
	log.info "Output directory: $params.outdir".center(74)
	log.info "Duration: $workflow.duration".center(74)
	log.info "Nextflow version: $workflow.nextflow.version".center(74)
	log.info "".center(74, "=")
}

workflow.onError {
	println "Pipeline execution stopped with the following message: ${workflow.errorMessage}".center(74, "=")
}
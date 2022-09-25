// Workflows for chewBBACA_tree
include { CLEAN_LABELS } from "${params.module_dir}/CLEAN_LABELS.nf"

workflow MAIN_WORKFLOW {
    chewBBACA_ch=Channel.fromPath(params.raw_results, checkIfExists:true)

    CLEAN_LABELS (chewBBACA_ch, params.outdir)
}

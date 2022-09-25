// Workflows for chewBBACA_tree
include { CLEAN_LABELS } from "${params.module_dir}/CLEAN_LABELS.nf"
include { FILTER_MISSING } from "${params.module_dir}/FILTER_MISSING.nf"

workflow MAIN_WORKFLOW {
    chewBBACA_ch=Channel.fromPath(params.raw_results, checkIfExists:true)

    CLEAN_LABELS (chewBBACA_ch, params.outdir)
    FILTER_MISSING (CLEAN_LABELS.out.clean_labels_ch, params.maxmissing, params.outdir)
    //(FILTER_MISSING.out.filter_missing_ch, params.outdir)


}

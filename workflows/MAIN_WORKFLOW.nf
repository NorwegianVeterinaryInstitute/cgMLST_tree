// Workflows for chewBBACA_tree
include { CLEAN_LABELS } from "${params.module_dir}/CLEAN_LABELS.nf"
include { FILTER_MISSING } from "${params.module_dir}/FILTER_MISSING.nf"
include { HAMMING_DISTANCE } from "${params.module_dir}/HAMMING_DISTANCE.nf"
include { DISSIMILARITY_MATRIX } from "${params.module_dir}/DISSIMILARITY_MATRIX.nf"
include { CLUSTERING } from "${params.module_dir}/CLUSTERING.nf"
include { TREE_PLOT } from "${params.module_dir}/TREE_PLOT.nf"

workflow MAIN_WORKFLOW {
    chewBBACA_ch=Channel.fromPath(params.raw_results, checkIfExists:true)

    CLEAN_LABELS (chewBBACA_ch, params.outdir)
    FILTER_MISSING (CLEAN_LABELS.out.clean_labels_ch, params.maxmissing, params.outdir)
    HAMMING_DISTANCE(FILTER_MISSING.out.filter_missing_ch, params.outdir)
    DISSIMILARITY_MATRIX(CLEAN_LABELS.out.clean_labels_ch, params.outdir)
    CLUSTERING(DISSIMILARITY_MATRIX.out.dissimilarity_ch, params.method, params.outdir)
    TREE_PLOT(CLUSTERING.out.clustering_ch, params.outdir)
}

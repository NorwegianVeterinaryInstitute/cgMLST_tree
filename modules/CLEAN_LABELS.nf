process CLEAN_LABELS {
    publishDir "$params.outdir", pattern: "clean_results_alleles.tsv", mode: "copy", failOnError: true
    publishDir "$params.logsdir", pattern: "CLEAN_LABELS.log", mode: "copy", failOnError: true
  
    input:
    path 'input.tsv' 
    val params.outdir 
    
    output:
    path "clean_results_alleles.tsv", emit: clean_labels_ch

    script:
    """
    Rscript ${params.script_dir}/clean_labels.R input.tsv clean_results_alleles.tsv &> CLEAN_LABELS.log
    """
}

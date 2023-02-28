process FILTER_MISSING {
    publishDir "$params.outdir", pattern: "*.tsv", mode: "copy", failOnError: true
    publishDir "$params.logsdir", pattern: "FILTER_MISSING.log", mode: "copy", failOnError: true
  
    input:
    path 'input.tsv' 
    val maxmissing
    val params.outdir 
    
    output:
    path "filtered_results_alleles.tsv", emit: filter_missing_ch
    path "statistics_missing_loci.tsv"

    script:
    """
    Rscript ${params.script_dir}/filter_missing.R input.tsv $maxmissing filtered_results_alleles.tsv &> FILTER_MISSING.log
    """
}

process DISSIMILARITY_MATRIX {
    publishDir "$params.outdir", pattern: "dissimilarity.tsv", mode: "copy", failOnError: true
    publishDir "$params.logsdir", pattern: "DISSIMILARITY.log", mode: "copy", failOnError: true
  
    input:
    path 'input.tsv' 
    val params.outdir 
    
    output:
    path "dissimilarity.tsv", emit: dissimilarity_ch
    

    script:
    """
    Rscript ${params.script_dir}/dissimilarity.R input.tsv dissimilarity.tsv &> DISSIMILARITY.log
    """
}

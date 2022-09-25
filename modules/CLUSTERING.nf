process CLUSTERING {
    publishDir "$params.outdir", pattern: "tree.nwk", mode: "copy", failOnError: true
    publishDir "$params.logsdir", pattern: "CLUSTERING.log", mode: "copy", failOnError: true
  
    input:
    path 'dissimilarity.rds' 
    val method 
    val params.outdir 
    
    output:
    path "tree.nwk", emit: clustering_ch
    

    script:
    """
    Rscript ${params.script_dir}/clustering.R dissimilarity.rds $method tree.nwk &> CLUSTERING.log
    """
}

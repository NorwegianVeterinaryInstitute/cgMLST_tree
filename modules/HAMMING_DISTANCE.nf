process HAMMING_DISTANCE {
    publishDir "$params.outdir", pattern: "hamming_distances.tsv", mode: "copy", failOnError: true
    publishDir "$params.logsdir", pattern: "HAMMING_DISTANCE.log", mode: "copy", failOnError: true
  
    input:
    path 'input.tsv' 
    val params.outdir 
    
    output:
    // I think we can remove this channel
    path "hamming_distances.tsv", emit: hamming_distance_ch
    

    script:
    """
    Rscript ${params.script_dir}/hamming.R input.tsv hamming_distances.tsv &> FILTER_MISSING.log
    """
}

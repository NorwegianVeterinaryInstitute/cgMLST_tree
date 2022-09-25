process TEMPLATE {

    publishDir "$params.logsdir", pattern: "*vsearch_params.log", mode: "copy", failOnError: true
  
    input:
    file tab
    
    output:
    path "*.tab", emit: vsearch_params_ch
    path "parameter_df.txt", emit: vsearch_parameter_df_ch
    // This allows to output the log
    file("*")

   script:
    """
    Rscript "${params.script_dir}/vsearch_param_from_tab.R" \
     &> TEMPLATE.log
    """
}

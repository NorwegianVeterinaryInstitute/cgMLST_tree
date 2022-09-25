process TREE_PLOT { 
    publishDir "$params.outdir", pattern: "*.{html, Rmd, sh, png}", mode: "copy", overwrite: false
    
    shell = [ '/bin/bash', '-ue' ]
    errorStrategy = 'ignore'

    input: 
    path tree 
    val params.outdir


    output:
    file("*.*")


    script:
    """
    cp "${params.script_dir}"/template_tree_annotation.Rmd .
    touch run.sh
    echo "#!bin/bash\n" > run.sh
    echo 'Rscript -e \\\' >> run.sh
    echo '"'"rmarkdown::render('template_tree_annotation.Rmd', 
                output_file = 'tree_report.html',
                params=list(
                    tree = 'tree.nwk',
                    method = '"$params.method"',
                    data = '"$params.raw_results"', 
                    author = '"$params.author_report"', 
                    )
                )"'"' | tr -d '\n' | tr -d ' ' >>  run.sh
    bash run.sh
"""
}

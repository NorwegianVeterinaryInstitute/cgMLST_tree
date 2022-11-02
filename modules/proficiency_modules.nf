
// 10 - x is for Preassembly Quality check 

// PREASSEMBLY 
process KRAKEN2 {
    publishDir "${params.outdir}/10_KRAKEN2", pattern: "*", mode: "copy", overwrite: false
 
    input:
    tuple val(ID), path(reads)
    path krakenDB
    val params.outdir

    output:
    path "*" 

    script: 
    """
    kraken2 --db krakenDB --output ${ID}.out  \
    --use-names --report ${ID}_report.txt --paired ${reads}
    cp .command.log ${ID}_kraken2.log
    cp .command.sh ${ID}_kraken2.sh
    """

}

process FASTQC {
    publishDir "${params.outdir}/11_FASTQC", pattern: "*", mode: "copy", overwrite: false
 
    input:
    tuple val(ID), path(reads)
    path adapters
    val params.outdir

    output:
    path "*.zip", emit: FASTQC_out
    file("*")

    script: 
    """
    fastqc -o . -a adapters reads
    cp .command.log ${ID}_fastqc.log
    cp .command.sh ${ID}_fastqc.sh
    """
}

// will need a collect on the channel 
process MULTIQC {
    publishDir "${params.outdir}/12_MULTIQC", pattern: "*", mode: "copy", overwrite: false
    
    input:
    path fastq_results
    val params.outdir

    output:
    file ("*") 

    script:
    """
    multiqc fastqc_results
    cp .command.log multiqc.log
    cp .command.sh multiqc.sh
    """
}

// python database_setup.py -s confindr_db_licence_evfi  -o confindr_db_2021-11-02
process CONFINDR {
    publishDir "${params.outdir}/13_CONFINDR", pattern: "*", mode: "copy", overwrite: false

    input:
    tuple val(ID), path(reads)     ? pair path 
    path confinderDB 
    val params.outdir

    output:
    file("*")

    script: 
    """
    confindr.py -v &> confindr.log
    confindr.py -i $indir -o . -d confinderDB
    #/Listeria_db_cgderived.fasta

    """


}

// ASSEMBLY 

process SHOVILL {
    publishDir "${params.outdir}/20_SHOVILL", pattern: "*", mode: "copy", overwrite: false

    input:
    tuple val(ID), path(reads) 
    val params.outdir
    
    output: 
    path "${ID}/contigs.fa", emit: shovill_out 
    file ("${ID}/*")

    script: 
    """
    shovill --outdir ${ID} --R1 test/R1.fq.gz --R2 test/R2.fq.gz / 
    --depth ${params.depth} /
    --gsize ${params.shovill_genomesize} --outdir . /
    --minlen ${params.minlen} --mincov ${params.mincov} /
    --assembler ${params.assembler} /
    --trim ${params.trim} /
    --cpus 0 
    """
}

// 30 x is for post assembly quality check 
process QUAST {
    publishDir "${params.outdir}/30_QUAST", pattern: "*", mode: "copy", overwrite: false

    input:
    tuple val(ID), path(reads) 
    path checkmDB
    path markerfile
    
    output: 
    file ("*")

    script: 
    """
    checkm data setRoot checkmDB
    checkm qa markerfile .
    
    """
}

process CHECKM {
    publishDir "${params.outdir}/31_CHECKM", pattern: "*", mode: "copy", overwrite: false

    input:
    tuple val(ID), path(reads) 
    path checkmDB
    path markerfile
    
    output: 
    file ("*")

    script: 
    """
    checkm data setRoot checkmDB
    checkm qa markerfile .
    
    """
}

process MAPPING {
    publishDir "${params.outdir}/32_MAPPING", pattern: "*", mode: "copy", overwrite: false
    
    input: 
    file reference
    tuple val(ID), path(reads)
    val params.outdir


    output:
    file final, emit: mapping_out
    file ("*")

    script:
    """
    bwa index reference
    bwa mem reference $R1_read $R2_read  | samtools sort -o PE_out -
    bwa mem reference $U_read  | samtools sort -o U_out -

    samtools merge merged PE_out U_out
    samtools sort -o final merged
    samtools index final

    
    rm PE_out
    rm U_out
    rm merged
    """


}


process QUALIMAP {
    publishDir "${params.outdir}/33_QUALIMAP", pattern: "*", mode: "copy", overwrite: false
    
    input:
    file bam  
    tuple val(ID), path (assembly) ? all assemblies 
    val serotype_scheme


    output: 
    file ("*")

    script:
    """
    qualimap bamqc -bam bam = $final -outdir . \
    --paint-chromosome-limits \
    --collect-overlap-pairs  \
    --output-genome-coverage ${ID}_coverage
    """


}


// Typing 

process MLST {
    publishDir "${params.outdir}/40_MLST", pattern: "*", mode: "copy", overwrite: false
    
    input: 
    tuple val(ID), path (assembly) ? all assemblies 
    val mlst_scheme


    output: 
    file ("*")

    script:
    """
    mlst --legacy --scheme mlst_scheme assemly --novel novel.fasta > MLST_results.tab
    """


}

process SEROMLST {
    publishDir "${params.outdir}/50_SEROTYPE", pattern: "*", mode: "copy", overwrite: false
    
    input: 
    tuple val(ID), path (assembly) ? all assemblies 
    val serotype_scheme


    output: 
    file ("*")

    script:
    """
    mlst --legacy --scheme mlst_scheme assemly --novel novel.fasta > MLST_results.tab
    """


}









// Docker 
docker pull staphb/shovill:latest
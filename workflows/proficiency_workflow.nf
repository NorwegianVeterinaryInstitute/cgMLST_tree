// Workflows for Lm proficiency test
include { KRAKEN2 } from ".modules/modules.nf"
include { FASTQC } from ".modules/modules.nf"
include { MULTIQC } from ".modules/modules.nf"
include { CONFINDR } from ".modules/modules.nf"
include { SHOWVILL } from ".modules/modules.nf"
include { QUAST } from ".modules/modules.nf"
include { MAPPING } from ".modules/modules.nf"
include { QUALIMAP } from ".modules/modules.nf"
include { CHECKM } from ".modules/modules.nf"
include { MLST } from ".modules/modules.nf"
include { SEROMLST } from ".modules/modules.nf"

workflow PROFICIENCY_WORKFLOW {
  
    reads_ch=Channel.fromFilePairs("${params.input}/*_R{1,2}.fastq.gz", checkIfExists:true)
    reads_ch.view()

    /*
    // Preassembly quality check 
    KRAKEN2(reads_ch, params.krakenDB, params.outdir)
    // Pavian run manually (for now - helper launch script though)
    FASTQC(reads_ch, params.adapters, params.outdir)
    MULTIQC(FASTQC.out.FASTQC_out.collect(), params.outdir)
    CONFINDR(reads_ch, params.confinderDB, params.outdir)

    // Assembly 
    SHOWVILL(reads_ch, params.outdir)

    // Assembly quality check 
    QUAST(SHOWVILL.out.showvill_out.collect()     )
    // on each 
    MAPPING(SHOWVILL.out.shovill_out, trimmed_reads_ch, params.outdir)
    QUALIMAP(MAPPING.out.mapping_out, )

    // reads or assembly ? 
    CHECKM(SHOWVILL.out.showvill_out, params.checkmDB, params.markerfile, params.outdir)

    
    
    // Typing  
    // MLST collected on all assemblies (we need with the ID)
    MLST(SHOWVILL.out.showvill_out.collect(), params.mlst_scheme, params.outdir)
    SEROMLST(SHOWVILL.out.showvill_out.collect(), params.serotype_scheme, params.outdir)
    
    // cgMLST typing and tree is done with https://github.com/NorwegianVeterinaryInstitute/cgMLST_tree 
    */
}

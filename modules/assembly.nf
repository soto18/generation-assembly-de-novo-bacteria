process RemoveDuplicates {
    conda 'config/decontamination-env.yml'
    publishDir 'results/', mode: 'copy'

    input:
        path clean_genome
        val output_name    

    output:
        path "${output_name}/assembly/*_no_duplicates.fastq.gz"

    script:
        """
        mkdir -p "${output_name}/assembly"
        filename=\$(basename "${clean_genome}" | sed 's/\\.gz\$//')
        seqkit rmdup "${clean_genome}" -o "${output_name}/assembly/\${filename}_no_duplicates.fastq.gz"
        """
}

process RunAssembly {
    conda 'config/assembly-env.yml'
    publishDir 'results/', mode: 'copy'

    input:
        path clean_genome
        val output_name    

    output:
        path "${output_name}/assembly/resulting_genome/*"   

    script:
        """  
        mkdir -p "${output_name}/assembly"

        flye --nano-hq "${clean_genome}" --out-dir "${output_name}/assembly/resulting_genome" --threads 8
        """       
}

process GenomePolishing {
    conda 'config/assembly-env.yml'
    publishDir 'results/', mode: 'copy'

    input:
        path assembled_genome
        path genome_no_duplicated
        val output_name    

    output:
        path "${output_name}/assembly/medaka_output/*"
        path "${output_name}/assembly/medaka_output/consensus.fasta", emit: consensus_genome
        path "${output_name}/assembly/medaka_output/calls_to_draft.bam", emit: bam_file


    script:
        """  
        mkdir -p "${output_name}/assembly"

        medaka_consensus -i "${genome_no_duplicated}" -d "${assembled_genome}" -o "${output_name}/assembly/medaka_output/" -t 16
        """       
}
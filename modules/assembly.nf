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
        path clean_genome
        val output_name    

    output:
        path "${output_name}/assembly"   

    script:
        """  
        mkdir -p "${output_name}/assembly"

        medaka_consensus -i genome_no_duplicates.fastq.gz -d out_nano/assembly.fasta -o medaka_output -t 4
        """       
}
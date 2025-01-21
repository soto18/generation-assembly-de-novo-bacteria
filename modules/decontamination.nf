process PrepareDecontamination {
    conda 'config/decontamination-env.yml'
    publishDir 'results', mode: 'copy'

    input:
        path genome_file
        val output_name

    output:
        path "${output_name}/filtered_sequences/${genome_file.baseName}.fa"

    script:
        """
        mkdir -p "${output_name}/filtered_sequences"

        # Convertir FASTQ a FASTA
        seqkit fq2fa "${genome_file}" -o "${output_name}/filtered_sequences/${genome_file.baseName}.fa"
        """
}

process MakeBlastDB {
    conda 'config/decontamination-env.yml'
    publishDir 'results', mode: 'copy'

    input:
        path db_fasta
        val output_name

    output:
        path "${output_name}/decontamination/db/${db_fasta.baseName}.*"

    script:
        """
        makeblastdb -in "${db_fasta}" -dbtype nucl -out "${output_name}/decontamination/db/${db_fasta.baseName}"
        """
}

process DetectContaminants {
    conda 'config/decontamination-env.yml'
    publishDir 'results', mode: 'copy'

    input:
        path db
        path query_seq
        val output_name

    output:
        tuple path("${output_name}/decontamination/contaminants_ids.txt"), 
              path("${output_name}/decontamination/blast_results.out")
        
    script:
        """
        mkdir -p "${output_name}/decontamination"

        # Ejecutar BLASTn
        blastn -db "../../../results/${output_name}/decontamination/db/escherichia_db" \
               -query "${query_seq}" \
               -out "${output_name}/decontamination/blast_results.out" \
               -num_threads 6 \
               -outfmt "6 qseqid sseqid pident evalue" \
               -evalue 0.00001 \
               -perc_identity 95 \
               -max_target_seqs 1

        # Generar lista de IDs de contaminantes
        cut -f1 "${output_name}/decontamination/blast_results.out" | sort | uniq > "${output_name}/decontamination/contaminants_ids.txt"
        """
}

process RemoveContamination {
    conda 'config/decontamination-env.yml'
    publishDir 'results', mode: 'copy'

    input:
        path contaminations_id
        path genome_file
        val output_name

    output:
        path "${output_name}/decontamination/genome_decontaminated.fastq.gz"

    script:
        """
        mkdir -p "${output_name}/decontamination"

        seqkit grep -v -f "${contaminations_id}" "${genome_file}" -o "${output_name}/decontamination/genome_decontaminated.fastq.gz"
        """
}
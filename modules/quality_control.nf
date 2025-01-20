process QualityControl {
    conda 'config/quality-control-env.yml'
    publishDir 'results', mode: 'copy'

    input:
        path input_file
        val output_name

    output:
        path "${output_name}/qc/*"

    script:
        """
        filename=\$(basename "${input_file}" | sed 's/\\.gz\$//')
        mkdir -p "${output_name}/qc"

        # Control de calidad inicial
        fastqc "${input_file}" --outdir "${output_name}/qc/" --threads 4
        nanoq --input "${input_file}" --stats -vv --report "${output_name}/qc/\${filename}_nanoq.stats"
        """
}


process ApplyFilters {
    conda 'config/quality-control-env.yml'
    publishDir 'results/', mode: 'copy'

    input:
        path input_file
        val output_name
        val min_len
        val min_qual

    output:
        path "${output_name}/filtered_sequences/*"
        
    script:
        """        
        # Aplicar filtro de calidad
        filename=\$(basename "${input_file}" | sed 's/\\.gz\$//')
        mkdir -p "${output_name}/filtered_sequences"
        
        nanoq --input "${input_file}" \
              --min-len "${min_len}" \
              --min-qual "${min_qual}" \
              -vv \
              --output "${output_name}/filtered_sequences/\${filename}_filter.fastq.gz" \
              --report "${output_name}/filtered_sequences/\${filename}_filter.stats"
        """
}

process ConcatFileQC {
    conda 'config/quality-control-env.yml'
    publishDir 'results/', mode: 'copy'

    input:
        path inicial_qc
        path filter_qc
        val output_name

    output:
        path "${output_name}/multiqc_results/*"   

    script:
        """  
        # MultiQC para generar un informe conjunto
        mkdir -p "${output_name}/multiqc_results"
        multiqc "../../../results/${output_name}/." -o "${output_name}/multiqc_results"
        """       
}        
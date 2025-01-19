process quality_control {
    conda 'config/quality-control-env.yml'
    publishDir 'results', mode: 'copy'

    input:
        path input_file
        val output_name
        val min_len
        val min_qual

    output:
        path "${output_name}/fastqc_results/*"
        path "${output_name}/nanoq_results/*"
        path "${output_name}/multiqc_results/*"

    script:
    """
    # Crear el directorio principal y subdirectorios
    mkdir -p "${output_name}/fastqc_results" "${output_name}/nanoq_results" "${output_name}/multiqc_results"

    # Control de calidad inicial
    fastqc '${input_file}' --outdir '${output_name}/fastqc_results' --threads 4
    nanoq --input '${input_file}' --stats -vv --report '${output_name}/nanoq_results/output_non_filter.stats'
    
    # Aplicar filtro de calidad
    nanoq --input '${input_file}' --min-len '${min_len}' --min-qual '${min_qual}' -vv --output '${output_name}/output_filter.fastq.gz' --report '${output_name}/nanoq_results/output_filter.stats'

    # Generar informe multiqc
    multiqc '${output_name}' -o '${output_name}/multiqc_results'
    """
}


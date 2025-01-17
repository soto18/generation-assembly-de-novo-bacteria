process quality_control {
    conda 'config/quality-control-env.yml' 
    publishDir 'results', mode: 'copy'    

    input:
        path input_file                  

    output:
        path "fastqc_results/*"          
        path "nanoq_results/*"           

    script:
    """
    mkdir -p fastqc_results nanoq_results
    
    # Control de calidad inicial
    fastqc '${input_file}' --outdir fastqc_results --threads 4
    nanoq --input '${input_file}' --stats -vv --report nanoq_results/output.stats
    
    # Aplicar filtros de calidad
    
    """
}


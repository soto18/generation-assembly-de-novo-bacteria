process Versions {
    conda 'config/quality-control-env.yml'
    publishDir 'results/', mode: 'copy'

    output:
        path "versions.txt"   

    script:
        """  
        nanoq --version >> versions.txt
        fastqc --version >> versions.txt
        multiqc --version >> versions.txt
        """       
}        
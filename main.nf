#!/usr/bin/env nextflow

params.input_file = null
params.output_name = null
params.min_len = null
params.min_qual = null

include { quality_control } from './modules/quality_control.nf'
include { test_versions } from './modules/decontamination.nf'

workflow {
    input_file_ch = Channel.fromPath(params.input_file)

    // Ejecutar procesos
    quality_control(input_file_ch, params.output_name, params.min_len, params.min_qual)
    remove_contamination()
}


#!/usr/bin/env nextflow

params.input_file = null

include { test_versions } from './modules/test_versions.nf'
include { quality_control } from './modules/quality_control.nf'

workflow {
    input_ch = Channel.fromPath(params.input_file)
    
    test_versions()
    quality_control(input_ch)
}


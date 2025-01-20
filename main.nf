#!/usr/bin/env nextflow

params.genome_file = null
params.output_name = null
params.min_len = null
params.min_qual = null

include { Versions } from './modules/versions.nf'
include { QualityControl } from './modules/quality_control.nf'
include { ApplyFilters } from './modules/quality_control.nf'
include { ConcatFileQC } from './modules/quality_control.nf'

workflow {
    genome_file_ch = Channel.fromPath(params.genome_file)

    // Ejecutar procesos
    Versions()

    inicial_qc = QualityControl(genome_file_ch, params.output_name)
    filter_qc = ApplyFilters(genome_file_ch, params.output_name, params.min_len, params.min_qual)
    ConcatFileQC(inicial_qc, filter_qc, params.output_name)
}

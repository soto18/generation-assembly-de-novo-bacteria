#!/usr/bin/env nextflow

params.genome_file = null
params.output_name = null
params.min_len = null
params.min_qual = null
params.contamination_db = null

include { Versions } from './modules/versions.nf'
include { QualityControl } from './modules/quality_control.nf'
include { ApplyFilters } from './modules/quality_control.nf'
include { ConcatFileQC } from './modules/quality_control.nf'

include { PrepareDecontamination } from './modules/decontamination.nf'
include { MakeBlastDB } from './modules/decontamination.nf'
include { DetectContaminants } from './modules/decontamination.nf'
include { RemoveContamination } from './modules/decontamination.nf'

include { RemoveDuplicates } from './modules/assembly.nf'
include { RunAssembly } from './modules/assembly.nf'
include { GenomePolishing } from './modules/assembly.nf'

include { DownloadDB } from './modules/assembly_analysis.nf'
include { AssemblyAnalysis } from './modules/assembly_analysis.nf'
include { GraphDepth } from './modules/assembly_analysis.nf'

workflow {
    genome_file_ch = Channel.fromPath(params.genome_file)
    contamination_file_ch = Channel.fromPath(params.contamination_db)

    Versions()

    // Control de calidad y filtros
    inicial_qc = QualityControl(genome_file_ch, params.output_name)
    filter_qc = ApplyFilters(genome_file_ch, params.output_name, params.min_len, params.min_qual)
    ConcatFileQC(inicial_qc, filter_qc, params.output_name)

    // Descontaminacion
    genome_filter = filter_qc.map { it[0] }
    query_seq = PrepareDecontamination(genome_filter, params.output_name)
    db = MakeBlastDB(contamination_file_ch, params.output_name)
    result = DetectContaminants(db, query_seq, params.output_name)
    id_contamination = result.map { it[0] }
    clean_genome = RemoveContamination(id_contamination, genome_filter, params.output_name)

    // Ensamble de genoma
    genome_no_duplicated = RemoveDuplicates(clean_genome, params.output_name)
    assembly_folder = RunAssembly(genome_no_duplicated, params.output_name)
    assembled_genome = assembly_folder.map { it[5] }
    genome_final = GenomePolishing(assembled_genome, genome_no_duplicated, params.output_name)

    // Analisis del ensamble
    consensus_genome = genome_final.consensus_genome
    bam_file = genome_final.bam_file
    downloaded_db = DownloadDB(params.output_name)
    data_to_graph = AssemblyAnalysis(downloaded_db, consensus_genome, bam_file, params.output_name)
    depth_file = data_to_graph.depth_file
    GraphDepth(depth_file, params.output_name)
}

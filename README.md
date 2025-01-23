# Ensamblaje de genoma de bacterias

## Índice
1. [Descripción](#descripción)
2. [Requisitos](#requisitos)
3. [Ejecución del pipeline](#ejecución-del-pipeline)
   - [Comando de ejecución](#comando-de-ejecución)
   - [Descripción de los parámetros](#descripción-de-los-parámetros)
4. [Resultados](#resultados)
5. [Raw data and preprocessing](#data)

---

## Descripción
El proyecto automatiza el ensamblaje de novo de genoma bacteriano a partir de datos de secuenciación sin procesar. El pipeline, implementado en Nextflow, incluye control de calidad, ensamblaje, descontaminación y análisis de métricas como calidad, completitud y cobertura del genoma ensamblado.

---

## Requisitos
- Nextflow v24.10.3.5933  
- Miniconda v24.11.2

---

## Ejecución del Pipeline

### Comando de ejecución
Para ejecutar el pipeline, utiliza el siguiente comando:

```bash
nextflow run main.nf 
  -with-conda \
  --genome_file input/Pseudomonas.gz \
  --contamination_db contamination/escherichia_db.fasta \
  --output_name pseudomonas \
  --min_len 30000 \
  --min_qual 15
```

### Descripción de parámetros
- --genome_file: Archivo en formato FASTQ que contiene las secuencias de nucleótidos del genoma de interés.  
- --contamination_db: Archivo multifasta que almacena las secuencias del organismo contaminante.  
- --output_name: Nombre del directorio de salida.  
- --min_len: Longitud mínima para filtrar las secuencias.  
- --min_qual: Calidad mínima para filtrar las secuencias.  

---

## Resultados
El pipeline genera los siguientes resultados organizados en directorios:

1. **Control de calidad**  
   - Reportes iniciales en `results/pseudomonas/inicial_qc`  
   - Resultados postfiltros en `results/pseudomonas/filtered_sequences`
   - Resultados combinados en `multiqc_results/multiqc_report.html`

2. **Descontaminación**  
   - Secuencias descontaminadas e información de contaminates en `results/pseudomonas/decontamination`

3. **Ensamblaje**  
   - Archivos ensamblados y gráficos en `results/pseudomonas/assembly`, incluyendo:
     - `genome_decontaminated.fastq_no_duplicates.fastq.gz`
     - Resultados de consenso en `medaka_output/consensus.fasta`
     - Ensamblajes intermedios en `resulting_genome`:
       - `draft_assembly.fasta`
       - `contigs.fasta`
       - `filtered_contigs.fasta`
       - Archivos de estadística como `contigs_stats.txt` y `assembly_info.txt`

4. **Análisis de profundidad**  
   - Gráfico de profundidad en `results/pseudomonas/assembly_analysis/profundidad_genoma.png`
   - Reportes:
     - Profundidad por base en `depth_per_base.txt`
     - Reportes de calidad y anotación en `assembly_analysis/report/`
     
## Datos sin procesar y ensamblaje del genoma
- Datos sin procesar están disponibles en [OneDrive](https://umagcl-my.sharepoint.com/:f:/g/personal/nicole_soto_funcionarios_umag_cl/EjGVhLwz1kxFg-2pKcruBrABIrg9bF_RDjstKR7xpZ_Gzg?e=oKGhCk)
- El ensamble resultante para el genoma de Pseudomonas aeruginosa esta disponible en [OneDrive](https://umagcl-my.sharepoint.com/:f:/g/personal/nicole_soto_funcionarios_umag_cl/EjGVhLwz1kxFg-2pKcruBrABIrg9bF_RDjstKR7xpZ_Gzg?e=oKGhCk)

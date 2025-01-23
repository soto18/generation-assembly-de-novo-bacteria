# Proyecto de Secuenciación y Análisis Genómico

## Índice
1. [Descripción](#descripción)
2. [Requisitos](#requisitos)
3. [Ejecución del Pipeline](#ejecución-del-pipeline)
   - [Comando de Ejecución](#comando-de-ejecución)
   - [Descripción de los Parámetros](#descripción-de-los-parámetros)
4. [Resultados](#resultados)

---

## Descripción
Este proyecto tiene como objetivo realizar la secuenciación y análisis genómico de muestras utilizando un flujo de trabajo automatizado implementado en Nextflow. El pipeline incluye pasos de control de calidad, ensamblaje, descontaminación y análisis de profundidad del genoma.

---

## Requisitos
- Nextflow v24.10.3.5933  
- Miniconda v24.11.2

---

## Ejecución del Pipeline

### Comando de Ejecución
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

### Descripción de los Parámetros
- --genome_file: Archivo en formato FASTQ que contiene las secuencias de nucleótidos del genoma de interés.  
- --contamination_db: Archivo multifasta que almacena las secuencias del organismo contaminante.  
- --output_name: Nombre del directorio de salida.  
- --min_len: Longitud mínima para filtrar las secuencias.  
- --min_qual: Calidad mínima para filtrar las secuencias.  

---

## Resultados
El pipeline genera los siguientes resultados organizados en directorios:

1. **Control de Calidad**  
   - Reportes iniciales en `results/pseudomonas/inicial_qc`  
   - Resultados combinados en `multiqc_results/multiqc_report.html`

2. **Descontaminación**  
   - Secuencias descontaminadas y archivos asociados en `results/pseudomonas/decontamination`

3. **Ensamblaje**  
   - Archivos ensamblados y gráficos en `results/pseudomonas/assembly`

4. **Análisis de Profundidad**  
   - Gráfico generado en `results/pseudomonas/profundidad_genoma.png`




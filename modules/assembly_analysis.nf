process DownloadDB {
    conda 'config/assembly-analysis-env.yml'
    publishDir 'results/', mode: 'copy'

    input:
        val output_name     

    output:
        path "${output_name}/CheckM2_database/uniref100.KO.1.dmnd", emit: checkm2_db

    script:
        """  
        mkdir -p "${output_name}/CheckM2_database"
        checkm2 database --download --path "${output_name}/"
        """
}

process AssemblyAnalysis {
    conda 'config/assembly-analysis-env.yml'
    publishDir 'results/', mode: 'copy'

    input:
        path checkm2_db
        path consensus_genome
        path bam_file
        val output_name    

    output:
        path "${output_name}/assembly_analysis/report"
        path "${output_name}/assembly_analysis/depth_per_base.txt", emit: depth_file

    script:
        """  
        mkdir -p "${output_name}/assembly_analysis"

        checkm2 predict --input "${consensus_genome}" --database_path "${checkm2_db}" -o "${output_name}/assembly_analysis/report"
        samtools depth "${bam_file}" > "${output_name}/assembly_analysis/depth_per_base.txt"
        """
}

process GraphDepth {
    conda 'config/assembly-analysis-env.yml'
    publishDir 'results/', mode: 'copy'

    input:
        path depth_file
        val output_name    

    output:
        path "${output_name}/assembly_analysis/profundidad_genoma.png"

    script:
        """
        python3 - << EOF
	import os
	import matplotlib.pyplot as plt
	import pandas as pd

	file_path = "${depth_file}"
	output_path = "${output_name}/assembly_analysis"

	# Crear el directorio de salida si no existe
	os.makedirs(output_path, exist_ok=True)

	columns = ["sequence", "position", "depth"]
	data = pd.read_csv(file_path, sep="\\t", names=columns)
	data = data[(data["position"] >= 0) & (data["depth"] >= 0)]
	data = data.sort_values(by="position")

	# Graficar la profundidad a lo largo de la posición
	plt.figure(figsize=(10, 6))
	plt.plot(data["position"], data["depth"], color="#00008B", linewidth=0.5)
	plt.title("Profundidad del genoma")
	plt.xlabel("Ubicación (pb)")
	plt.ylabel("Profundidad")
	plt.grid(True, linestyle="--", alpha=0.6)
	plt.savefig(f"{output_path}/profundidad_genoma.png", dpi=300)
	EOF
        """
}

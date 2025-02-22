#!/bin/bash
#SBATCH --job-name=dorado_demux
#SBATCH --partition=PARTITION_NAME  # doesn't need GPU  
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 20
#SBATCH --time=5-0
#SBATCH --mem 250G 
#SBATCH -o logs/dorado_demux-%j.out
#SBATCH -e logs/dorado_demux-%j.err

echo "$(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "Job Name: $SLURM_JOB_NAME"
echo -e "Number of CPUs allocated: $SLURM_CPUS_PER_TASK\n"

### 1. File/Dir Paths ### 
raw_main_dir=path/to/raw/files
input_basecalled_bam_dir=${raw_main_dir}/pod5_modified_basecall

demux_bam_outdir=${raw_main_dir}/demux_modified_basecall
mkdir -p ${demux_bam_outdir}

# 2. Run dorado barcode classification 
echo Starting dorado barcode classification using dorado demux...
echo "$(date)"
dorado/bin/dorado demux \
    --threads ${SLURM_CPUS_PER_TASK} \
    --no-classify \
    --recursive \
    --verbose \
    --output-dir ${demux_bam_outdir} \
    ${input_basecalled_bam_dir}

echo Done! 
echo Barcode Demultiplexed .bam files are located at: ${demux_bam_outdir}
echo "$(date)"
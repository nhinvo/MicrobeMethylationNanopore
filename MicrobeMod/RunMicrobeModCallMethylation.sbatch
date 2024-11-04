#!/bin/bash
#SBATCH --job-name=microbe-mod
#SBATCH --partition=sched_mit_chisholm
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 5
#SBATCH --time=5-0
#SBATCH --mem 60G 
#SBATCH --array=2-25%25
#SBATCH -o logs/call_methylation/%a-%j.out
#SBATCH -e logs/call_methylation/%a-%j.err

echo "$(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "Job Name: $SLURM_JOB_NAME"
echo "Array ID: $SLURM_ARRAY_TASK_ID"
echo "Number of CPUs: $SLURM_CPUS_PER_TASK"

eval "$(conda shell.bash hook)"
conda activate microbemod_dependencies

### 1. MicrobeMod call_methylation Prep ### 
# obtain paths to files 
file_name=$(sed "${SLURM_ARRAY_TASK_ID}q;d" data/samples.tsv | cut -f1 | tr -d '\r')
reference_genome_path=$(sed "${SLURM_ARRAY_TASK_ID}q;d" data/samples.tsv | cut -f10 | tr -d '\r')

# mapped bam dir (from dorado aligner)
mapped_outdir=/nobackup1b/users/chisholmlab/nvo/24_allison_methylation/Nanopore/MapNanoporeDemuxBam

# microbemod call_methylation output
output_dir=/nobackup1b/users/chisholmlab/nvo/24_allison_methylation/Nanopore/MicrobeModCallMethylationOutput
mkdir -p ${output_dir}

### 2. Run MicrobeMod ### 
echo Running MicrobeMod call_methylation on ${file_name}.sorted.bam...
echo "$(date)"

MicrobeMod/bin/MicrobeMod call_methylation \
    --bam_file ${mapped_outdir}/${file_name}.sorted.bam \
    --reference_fasta ${reference_genome_path} \
    --threads ${SLURM_CPUS_PER_TASK} \
    --output_prefix ${file_name} \
    --output_directory ${output_dir}

echo MicrobeMod call_methylation complete! 
echo "$(date)"
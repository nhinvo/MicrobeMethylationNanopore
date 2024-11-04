#!/bin/bash
#SBATCH --job-name=microbe-mod-annotate-rm
#SBATCH --partition=sched_mit_chisholm
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --time=5-0
#SBATCH --mem 10G 
#SBATCH -o logs/annotate_rm/%j.out
#SBATCH -e logs/annotate_rm/%j.err

echo "$(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "Job Name: $SLURM_JOB_NAME"
echo "Number of CPUs: $SLURM_CPUS_PER_TASK"

eval "$(conda shell.bash hook)"
conda activate microbemod_dependencies

### 1. MicrobeMod annotate_rm Prep ### 
# obtain paths to the 2 reference genomes 
MED4_fpath=data/ref_genomes/MED4.fna
NATL2A_fpath=data/ref_genomes/NATL2A.fna

# microbemod annotate_rm output
output_dir=/nobackup1b/users/chisholmlab/nvo/24_allison_methylation/Nanopore/MicrobeModAnnotateRMOutput
mkdir -p ${output_dir}

### 2. Run MicrobeMod ### 
echo Running MicrobeMod annotate_rm on MED4 reference genome...
echo "$(date)"

MicrobeMod/bin/MicrobeMod annotate_rm \
    --fasta ${MED4_fpath} \
    --output_prefix MED4 \
    --output_directory ${output_dir} \
    --threads ${SLURM_CPUS_PER_TASK}

echo MicrobeMod annotate_rm on MED4 genome complete! 

echo Running MicrobeMod annotate_rm on NATL2A reference genome...
echo "$(date)"

MicrobeMod/bin/MicrobeMod annotate_rm \
    --fasta ${NATL2A_fpath} \
    --output_prefix NATL2A \
    --output_directory ${output_dir} \
    --threads ${SLURM_CPUS_PER_TASK}

echo MicrobeMod annotate_rm on NATL2A genome complete! 
echo "$(date)"

echo Done!


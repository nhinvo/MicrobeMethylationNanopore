#!/bin/bash
#SBATCH --job-name=map-dorado-minimap2
#SBATCH --partition=PARTITION_NAME
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 10
#SBATCH --time=5-0
#SBATCH --mem 120G 
#SBATCH --array=2-END%NUMBER
#SBATCH -o logs/mapping-%a-%j.out
#SBATCH -e logs/mapping-%a-%j.err

echo "$(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "Job Name: $SLURM_JOB_NAME"
echo "Array ID: $SLURM_ARRAY_TASK_ID"
echo "Number of CPUs: $SLURM_CPUS_PER_TASK"


### 1. dorado minimap2 mapping prep ### 
# obtain paths to files 
file_name=$(sed "${SLURM_ARRAY_TASK_ID}q;d" data/samples.tsv | cut -f1 | tr -d '\r')
input_bam_read_path=$(sed "${SLURM_ARRAY_TASK_ID}q;d" data/samples.tsv | cut -f2 | tr -d '\r')
reference_genome_path=$(sed "${SLURM_ARRAY_TASK_ID}q;d" data/samples.tsv | cut -f3 | tr -d '\r')

# output dir 
mapped_outdir=path/to/outputdir/MapNanoporeDemuxBam
mkdir -p ${mapped_outdir}

### 2. Run dorado mapping on .bam file ### 
echo "Beginning mapping reads in ${file_name} to reference ${reference_genome_path}..."

dorado/bin/dorado aligner \
    ${reference_genome_path} \
    ${input_bam_read_path} \
    --threads ${SLURM_CPUS_PER_TASK} \
    --verbose \
    > ${mapped_outdir}/${file_name}.bam

echo Completed dorado aligner on ${file_name}!

### 3. Samtools sort and index ### 
eval "$(conda shell.bash hook)"
conda activate samtools

echo "Beginning samtools sort and index on mapped bam file..."

samtools sort \
    --threads ${SLURM_CPUS_PER_TASK} \
    --output-fmt BAM \
    -o ${mapped_outdir}/${file_name}.sorted.bam \
    ${mapped_outdir}/${file_name}.bam

samtools index \
    --threads ${SLURM_CPUS_PER_TASK} \
    --output ${mapped_outdir}/${file_name}.sorted.bam.bai \
    ${mapped_outdir}/${file_name}.sorted.bam

echo samtools sort and index complete. 
echo Done!
echo "$(date)"
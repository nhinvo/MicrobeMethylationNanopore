#!/bin/bash
#SBATCH --job-name=fast5_prep
#SBATCH --partition=PARTITION_NAME  # name of partition to submit job to 
#SBATCH --time 2-0  # 2 days 
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 20  # number of cores/CPUs/threads  
#SBATCH --mem 250G  # memory to allocate 
#SBATCH -o logs/fast5_prep-%j.out
#SBATCH -e logs/fast5_prep-%j.err

# Purpose: to convert all fast5 files to pod5
# Reason: dorado works faster/better on pod5 files 

echo "$(date)"

source activate pod5

fast5_dir=path/to/fast5/directory
cd ${fast5_dir}

### 1. Convert fast5 to pod5 in the same data dir ### 
echo Beginning fast5 to pod5 conversion... 

# convert fast5 to pod5 (in the same directory)
pod5 convert fast5 \
    *.fast5 \
    --threads ${SLURM_CPUS_PER_TASK} \
    --output . --one-to-one .

echo Completed fast5 to pod5 conversion. 

### 2. move pod5 to different dir ### 
echo Moving pod5 files to separate directory named pod5_pass/...
cd ../
mkdir -p pod5_pass
mv fast5_pass/*pod5 pod5_pass/

echo Done! 
echo "$(date)"

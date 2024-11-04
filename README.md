# NanoporePreprocessing
## Dependencies
### 1. Installing pod5
1. Create new environment with python version >= 3.8: `conda create -n pod5 python=3.8`
2. Activate environment: `conda activate pod5`
3. Download pod5 using pip: `python3 pip install --user pod5`

### 2. Installing dorado 
Dorado Github: https://github.com/nanoporetech/dorado 
1. Change directory into: `cd NanoporePreprocessing`
2. Download the latest version of dorado for Linux: `wget https://cdn.oxfordnanoportal.com/software/analysis/dorado-0.8.2-linux-x64.tar.gz`
3. Unzip the downloaded software into dorado/ directory: `tar -xzf dorado-0.8.2-linux-x64.tar.gz`
4. Change name of directory: `mv dorado-0.8.2-linux-x64 dorado`

## Checking GPU Information In Partitions
Check partitions and whether they have GPUs: `sinfo -o "%P %G %D %N"`
    - Once  a node with GPU has been identified, check specifications of nodes using: `scontrol show node [nodename]`

## Steps
### 1.fast5_prep.sbatch
Purpose: to convert .fast5 to .pod5 files.  
To-do:  
1. Change path to .fast5 file path on line 19: `fast5_dir=path/to/fast5/directory` 
2. Change partition name in line 3 and other SBATCH specifications as needed  
3. Run slurm script using: `sbatch 1.fast5_prep.sbatch`  

Script will create pod5 files in the same directory and move them into a directory called pod5_pass/ in the parent directory. 

### 2.dorado_prep.py 
Purpose: to create multiple .tsv files that split pod5 files into multiple groups so that dorado basecalling can be parallelized.  
To-do:  
1. Ensure pandas is installed (through conda or other methods)
2. Change path to pod5 directory created in step 1.fast5_prep.sbatch 
3. Run python script using: `python3 2.dorado_prep.py`

### 3.dorado_basecalling.sbatch
Purpose: to run dorado basecalling on all pod5 files.  
To-do:  
1. Install dorado 
2. Install basecall models: 
a. Create directory for basecall models: `mkdir basecall_models`
b. Change directory: `cd basecall_models`
b. Download models: 
    i. `../dorado/bin/dorado download --model dna_r10.4.1_e8.2_400bps_sup@v5.0.0`
    ii. `../dorado/bin/dorado download --model dna_r10.4.1_e8.2_400bps_sup@v5.0.0_6mA@v1`
    iii. `../dorado/bin/dorado download --model dna_r10.4.1_e8.2_400bps_sup@v5.0.0_4mC_5mC@v1`
3. Change basecall output path in line 32: `basecall_outdir=path/to/outputdir/pod5_modified_basecall/${group_name}`
4. Change parition name in line 3 
5. Change array specifications in line 10
6. Run slurm script using: `sbatch 3.dorado_basecalling.sbatch`

### 4.dorado_demux.sbatch
Purpose: to demultiplex all pod5 files into their respective barcodes (samples)
To-do: 
1. Change path to parent directory of raw files on line 18: `raw_main_dir=path/to/raw/files`
    - Note: this should be the parent directory where pod5_modified_basecall/ output directory in step 3 is located. 
2. Change partition name in line 3 
2. Run script: `sbatch 4.dorado_demux.sbatch`

### 5.map_bam.sbatch
Purpose: to map .bam files against reference genomes 
To-do: 
1. Create a samples.tsv file that contains 3 columns: 
a. 1st column: file name. 
b. 2nd column: path to .bam file that has been demultiplexed in script 4.dorado_demux.sbatch 
c. 3rd column: path to reference genome for the sample (either relative or absolute)
2. Edit slurm SBATCH configurations 
    - Note: if your samples.tsv file does not have a header line (column names), start the array at 1. 
3. Change path to output directory in line 27: `mapped_outdir=path/to/outputdir/MapNanoporeDemuxBam`
4. Run the script using: `sbatch 5.map_bam.sbatch`


# MicrobeMod
## Dependencies
### 1. Install MicrobeMod

## Steps
### 1. Copy ref_genomes/ and samples.tsv files: 
1. Make data/ directory and cd into it 
2. Copy samples.tsv file from NanoporePreprocessing/data/
3. Copy ref_genomes/ directory from NanoporePreprocessing/data/

### 2. 
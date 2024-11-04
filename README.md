# NanoporePreprocessing
## Dependencies
### 1. Installing pod5
Create an environment named pod5 with package pod5 installed
    - `insert command to install here`

### 2. Installing dorado 

## Steps
### 1.fast5_prep.sbatch
Purpose: to convert .fast5 to .pod5 files.  
To-do:  
    1. Change path to .fast5 file path on line 19: `fast5_dir=path/to/fast5/directory`  
    2. Run slurm script using: `sbatch 1.fast5_prep.sbatch`  

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
    2. Install basecall models 
    3. Change basecall output path in line 32: `basecall_outdir=path/to/outputdir/pod5_modified_basecall/${group_name}`
    4. Run slurm script using: `sbatch 3.dorado_basecalling.sbatch`

#### 4.dorado_demux.sbatch



# MicrobeMod

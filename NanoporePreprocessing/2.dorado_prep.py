"""
Purpose: to create multiple .tsv files that split pod5 files into 
multiple groups so that dorado basecalling can be parallelized 

N.N.Vo 11/03/24 
"""
from pathlib import Path 
import pandas as pd 

def main():
    Path('data/pod5_groups').mkdir(exist_ok=True, parents=True)

    pod5_dir = "path/to/pod5_pass"

    # file name of all pod5 files in dir 
    pod5_fpaths = [str(fpath) for fpath in Path(pod5_dir).glob('*.pod5')]
    print(f'Total pod5 files: {len(pod5_fpaths)}')

    # split file name list into sublists of 250 each 
    pod5_fpaths_sublists = [pod5_fpaths[i:i + 250] for i in range(0, len(pod5_fpaths), 250)]

    sublist_lens = []  # list of lengths of sublist - to check 
    for i, pod5_sublist in enumerate(pod5_fpaths_sublists):
        i += 1  # group number 

        # turn list of paths into DataFrame 
        df = pd.DataFrame({'pod5_fpath': pod5_sublist})

        # obtain file name 
        df['fname'] = df['pod5_fpath'].str.split('/').str[-1].str.replace('.pod5', '')

        # save list of files 
        df.to_csv(f'data/pod5_groups/pod5_group_{i}.tsv', sep='\t', index=False, header=False)

        # count number of files 
        sublist_lens.append(len(df))

    print(f'Total pod5 files in all sublists: {sum(sublist_lens)}')

main()
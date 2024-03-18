import argparse
import sys
from Bio import SeqIO

def parse_args(args):
    
    parser = argparse.ArgumentParser(
    prog="split_fasta.py",
    description="Step1. split multiple fasta downloaded from GISAID and saved as: format is 'Isolate name | Segment | Isolate ID'.Each fasta file will be saved as 'segt_IsolateID.fasta'",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    
    parser.add_argument("--fasta",
                        action="store",
                        required=True,
                        help="multifasta file")
    parser.add_argument("--outdir",
                        action="store",
                        required=True,
                        help="directory for output")
    args = vars(parser.parse_args())
    return args

# %% Functions 
# %% SCRIPT 

if __name__ == '__main__':
    args = parse_args(sys.argv[1:])
    
    with open(args["fasta"]) as handle:
        for record in SeqIO.parse(handle, "fasta"):
            current_name = record.id.split("|") 
            new_name = current_name[1] + "_" + current_name[2] + ".fasta"
            SeqIO.write(record, args["outdir"] + "/" + new_name, "fasta")
    handle.close()


## Usage eg
# python split_fasta.py --fasta 2023-09-28_gisaid_epiflu_sequence.fasta --outdir split

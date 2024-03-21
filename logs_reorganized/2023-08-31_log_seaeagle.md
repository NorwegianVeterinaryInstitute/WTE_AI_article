


Sanitizing sequences 

```bash 
# removing ref gaps and uppercase (so could to that above) and validate according to alfabet
cd 
conda activate seqkit
seqkit seq -guv xx.fasta >> xx_sanitized.fasta 
conda deactivate
```

Orienting the sequences in the segments to align with vsearch 
! if crop aware that some ref shorter for NA (because not complete)
```bash 
# Orienting
cd 

conda activate vsearch
vsearch --notrunclabels --log HAx_vsearch_orient.log --orient HA_sanitized.fasta --db HA_vsearch_ref_sanitized.fasta --fastaout HA_vsearch_ref_sanitized_oriented.fasta --notmatched HA_orient_not_matched.fasta
```


In frame multiple alignment using XX as reference 
- for HA 
- for NA 
- genotype H5N 
- 



#AI 
#genotype

file with information: [[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/genotypes_data/Table_genotypes_Britt.xlsx|Table_genotypes_Britt]]
modification of file ref_genotypes 
- splitting collumns and homogeneizing names - in red what I have modified  - into two sheets 


- reference sequences table 
	- year 2011-2019 - should not be many we could get as batch 
- genotypes 
	- has the alleles - that apparently are provided by the reference 

Avian nucleotide genome:  segment protein encoding: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3074182/
![[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/notes/Pasted_image_0231024092031.png]]

https://en.wikipedia.org/wiki/H5N1_genetic_structure

## Preparing MSA of reference files and representative files

### preparing fasta files - separating the sequences from the different segments 

merging all the data into one file per sequence / protein 

```shell 
cat references_files/*_sequence.fasta > references.fasta 
cat references_files/*_protein.fasta > references_protein.fasta 

cat representative_files/*_sequence.fasta > representative.fasta 
cat representative_files/*_protein.fasta > representative_protein.fasta 
```

splitting in individual segments 
Because we used the format `Isolate name | Segment | Isolate ID`  in GISAID to encode sequences: 

```shell 
SCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/split_fasta.py"
conda activate biopython

# for sequences 
python $SCRIPT --fasta representative.fasta --outdir representative_files_seq_segments 
python $SCRIPT --fasta references.fasta --outdir references_files_seq_segments 

# for proteins 
```
proteins - some seems poorly formatted do not know why - but only need them if a problem - so I do not take care of that ...

now reorganizing in subfolders per segments - for each dataset 

```shell
mkdir HA
mv HA*.fasta HA 

mkdir PB2
mv PB2*.fasta PB2

mkdir PB1
mv PB1*.fasta PB1

mkdir NS 
mv NS*.fasta NS

mkdir PA 
mv PA*.fasta PA

mkdir NP
mv NP*.fasta NP 

mkdir NA
mv NA*.fasta NA 

mkdir MP
mv MP*.fasta MP

segt=( HA PB2 PB1 NS PA NP NA MP )
echo ${segt[@]}
echo ${segt[0]}

for seg in ${segt[@]}
do 
echo ${seg}
cat ${seg}/*.fasta >  ${seg}.fasta 
done 

```


Now we focus on the segments HA and NA  first for making references MSA - in frame  - for each set ... 
but I think we need to rename the sequences according to the genotypes - so it will be easier to see when match in vsearch 


### renaming the sequences - so we can use those in an easier way for vsearch 
- references and representative sequences 
	- for know in 2 datasets because I want to see if the reference numbering corresponds to genotype or not 
	- we have alleles for the representative 

==rnotebook: [[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/notes/2023-10-18_Genotype_data_prep_datasets|2023-10-18_Genotype_data_prep_datasets]]
metadata and acknowledgments also wrangled each in one file, so its easier to use afterwards ==
==segments renamed with headers each in their own respective folder - moving all in wrangled folder ==

## Cropping in Frame 
Trying to do that in megaX (windows)

Cropping in Frame 
- [ ] references 
	- [x] HA
	- [x] NA
- [ ] representative - using vsearch 
	- [x] HA
	- [x] NA

# HA 
- cropping to frame - folder: genotypes_data>wrangled>references_new_headers 
	- megaX for cropping in frame 
	- file: _cropped_HA_ref_newheader.mas
	- export: HA_nuc_protein_non_aligned.fas 
## vsearch setup 
1. Test to understand the role and numbering of reference sequences 
Now trying to classify reference sequences to see if they correspond to alleles that are in the representative files 
and see if they can be used to get the type also 

Trial with HA to see if my idea works before doing the rest. 

**Trial to crop to frame using vsearch** 
- need to remove gaps with seqkit - stupid mega put gaps 

```shell 
cd 12302_Avian_influenza_2023/analysis/method_development/vsearch_cropping_test

conda activatge seqkit 
seqkit seq -g -o HA_frame_non_alinged_sanitized_references.fasta HA_nuc_protein_non_aligned_references.fasta 

conda activate vsearch
vsearch  --db HA_frame_non_alinged_sanitized_references.fasta  --usearch_global HA_ref_newheader_representative.fasta \
--id 0.95 --iddef 3 \
--userout test_frame_cropping_alignment.txt \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxaccepts 1 --maxrejects 50 \
--notrunclabels \
--alnout test_frame_cropping_alignment.aln \
--fastapairs test_frame_cropping_fasta_pairs.aln \
--matched test_frame_cropping_matched.fasta \
--notmatched test_frame_cropping_notmatched.fasta \
--log test_frame_cropping_vsearch.log 

#Matching unique query sequences: 66 of 66 (100.00%)
```

- so what do we learn : 
	- The reference number is definitively not the allele number. 
	- see if managed to get the frame with first set 
![[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/notes/vsearch_iddef.excalidraw.png | 400]] 

Hum, possible that for our purpose iddef2 would be better - than iddef 3 but as the weight of gaps is not so high iddef3 should work also for incomplete sequences ...
all sequences are matched 
- opening the pair alignment in mega - for manual check cropping of frame 
-  the cropping works for most sequences BUT failed for one ... trying to see if better different for iddef 2 - and increasing similarity value - 
	- modify parameters - search everything, and then output the best one 

```shell 
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/analysis/method_development/vsearch_cropping_test_iddef2


conda activate vsearch
vsearch  --db HA_frame_non_alinged_sanitized_references.fasta  --usearch_global HA_ref_newheader_representative.fasta \
--id 0.985 --iddef 2 \
--userout test_frame_cropping_alignment.txt \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 --alnout test_frame_cropping_alignment.aln \
--fastapairs test_frame_cropping_fasta_pairs.aln \
--matched test_frame_cropping_matched.fasta \
--notmatched test_frame_cropping_notmatched.fasta \
--log test_frame_cropping_vsearch.log  --notrunclabels 

```
 
ok same two sequences that have problems 
==Conclusion: The alignment will still need to be inspected for those that are short, and its important to get good references for cropping ==
==seems to work for most but not all== 
Seems to works exacly as iddef 3 - but this should maximize the length 

Conclusion:
Need correcting the representative that are might not be cropped correctly (visible in length alignment) and in alignment itself
- need to check both start and end 
- Those that are to check - this is because the query length (qs) are shorter not the references - so ok 
- [x] 20\|HA\|H5N8\|B_A/chicken/Russia_Novosibirsk_region/3-1/2020\|H5N8\|EPI_ISL_739690| 
- [x] 20|HA|H5N5|I_A/sea_eagle/Norway/2022-07-100_22VIR2882-2/2022|H5N5|EPI_ISL_12028892
- [x] 20|HA|H5N1|AG_A/duck/Bulgaria/827-2_22VIR778-8/2021|H5N1|EPI_ISL_11009382

Note:
- The representative files have genotype indicated G_bane ,,,
- The references files do not have that.  

**Filtering the queries from the pairwise alignment to optain only the queries:** 
The query is always first and the target always second - use R script to write the queries then [[filtering_frame_cropping_vsearch.R]]


```shell 
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/analysis/method_development/vsearch_cropping_test_iddef2

MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT -h
Rscript $MYSCRIPT --alignment test_frame_cropping_fasta_pairs.aln.fasta --output HA_representative_inframe.fasta 
```
Rechecking in mega - correct - same sequences that were not aligned totally 

**MSA - Jalview - Muscle - protein alignment - default preset** 


```
Parameters:
Alignment of /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/analysis/method_development/vsearch_cropping_test_iddef2/HA_representative_inframe.fasta
Job details
**Using ServerPreset: Protein alignment(Fastest speed)**
Job Output:
Started Mon Oct 23 18:07:13 2023
/homes/www-jws2/servers/tomcat-8.5.11_jaba-2.2prod/webapps/jabaws/binaries/src/muscle/muscle -clwstrict -quiet -verbose -nocore -log stat.log -in input.txt -out result.txt -maxiters 1 -diags -sv -distance1 kbit20_3 
Alphabet DNA

MUSCLE v3.8.31 by Robert C. Edgar
http://www.drive5.com/muscle

Profile-profile score    SPN
Max iterations           1
Max trees                1
Max time                 (No limit)
Max MB                   4294965597
Gap open                 -400
Gap extend (dimer)       0
Gap ambig factor         0
Gap ambig penalty        -0
Center (LE)              0
Term gaps                Half
Smooth window length     7
Refine window length     200
Min anchor spacing       32
Min diag length (lambda) 24
Diag margin (mu)         5
Min diag break           1
Hydrophobic window       5
Hydrophobic gap factor   1.2
Smooth score ceiling     999
Min best col score       90
Min anchor score         90
SUEFF                    0.1
Brenner root MSA         False
Normalize counts         False
Diagonals (1)            True
Diagonals (2)            True
Anchors                  True
MSF output format        False
Phylip interleaved       False
Phylip sequential        False
ClustalW output format   True
Catch exceptions         True
Quiet                    True
Refine                   False
ProdfDB                  False
Low complexity profiles  True
Objective score          SPM
Distance method (1)      Kbit20_3
Clustering method (1)    UPGMB
Root method (1)          Pseudo
Sequence weighting (1)   ClustalW
Distance method (2)      PctIdKimura
Clustering method (2)    UPGMB
Root method (2)          Pseudo
Sequence weighting (2)   ClustalW
"MUSCLE: multiple sequence alignment with high accuracy and high throughput"
Nucleic Acids Res. 32(5):1792 (2004)

MORE INFORMATION: http://www.drive5.com/muscle/
```

This is brillant, works very nicely :D 

Now looking at the diversity of the references sequences / with genotypes 

- number of nucleotides differences in the alignments - using snp-dist tseeman : https://github.com/tseemann/snp-dists?search=1 

```
conda activate snp-dist 
# all differences (incl - )
snp-dists -a -m HA_representative_inframe_jalview_palign_muscle.fasta > all_diff.tsv
# only AGTC 
snp-dists -m HA_representative_inframe_jalview_palign_muscle.fasta > AGTC_diff.tsv
```

We need a little script for getting the idea of differences between alleles 


- iqtree to have an idea of the bushiness  of the references genotypes 
```
conda activate iqtree 
iqtree --version
#IQ-TREE multicore version 2.2.2.9 COVID-edition for Linux 64-bit built Aug  6 2023
#Developed by Bui Quang Minh, James Barbetti, Nguyen Lam Tung,
#Olga Chernomor, Heiko Schmidt, Dominik Schrempf, Michael Woodhams, Ly Trong Nhan.

iqtree -s HA_representative_inframe_jalview_palign_muscle.fasta  -m MFP+F+I  -B 1000 -T AUTO

MFP model finder that tests the free rate model 
+F empirical base frequencies 
+I allow for proportion of invariable sites
+R rate 
-T threads 
```
ok the tree is weird because of all is 20 - HA  seems major subgroups not well resolved - so not enough difference to group them consistently, so could be ok. 

==Ok - so when gaps are not counted, snp distances varies from 0 to 35 max for a max pf 1703 bp == - on the protein coding gene - this is quiet a lot of variation 
when all alleles are given as identical ! 
"H5N1" "H5N2" "H5N3" "H5N4" "H5N5" "H5N8" so all H5 so not to bad 

See Rscript : [[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/2023-10-24_SNP_distances_genotypes.Rmd|2023-10-24_SNP_distances_genotypes]]


# NA
- cropping to frame - folder: genotypes_data>wrangled>references_new_headers 
	- megaX for cropping in frame 
	- file: _cropped_NA_ref_newheader.mas
	- export : NA_nuc_protein_non_aligned.fas

## vsearch - cropping of representative 

sanitizing headers 
```shell 
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/analysis/method_development/NA/vsearch_crop_representative
cp 12302_Avian_influenza_2023/data/genotypes_data/wrangled/references_new_headers/NA_nuc_protein_non_aligned.fas NA_nuc_protein_non_aligned.fasta 
cp 12302_Avian_influenza_2023/data/genotypes_data/wrangled/representative_new_headers/NA_ref_newheader.fasta NA_representative_newheader.fasta 


conda activatge seqkit 
seqkit seq -g -o NA_frame_non_alinged_sanitized_references.fasta NA_nuc_protein_non_aligned.fasta 
```


```shell
conda activate vsearch
vsearch  --db NA_frame_non_alinged_sanitized_references.fasta  --usearch_global NA_representative_newheader.fasta \
--id 0.95 --iddef 2 \
--userout NA_representative_frame_cropping_alignment.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 --alnout  NA_representative_frame_cropping_alignment.aln \
--fastapairs  NA_representative_frame_cropping_alignment_pairs.fasta \
--matched  NA_representative_frame_cropping_matched.fasta \
--notmatched  NA_representative_frame_cropping_notmatched.fasta \
--log  NA_representative_frame_cropping_vsearch.log  --notrunclabels 
```

so we have some that are not matched ... 
We need anyway to recheck manually 
- removing the references 
(hum, we could have used the matched instead ? but I want to be able to look at that ...)
```
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
#Rscript $MYSCRIPT -h
Rscript $MYSCRIPT --alignment NA_representative_frame_cropping_alignment_pairs.fasta --output NA_representative_inframe.fasta
```

now opening in megaX  .... NA_representative_inframe.fasta AND adding the non matched ... to the alignment 

- Non matched:  adding those manually to the alignment - looking at translation 
- [ ] 20|NA|H5N8|U_A/Towny_owel/Sweden/SVAU210406SZ0042/KN001362/M-2021|H5N8|EPI_ISL_2574053 
- [ ] 20|NA|H5N8|S_A/northern_goshawk/Sweden/SVA210224SZ0431/KN000626/2021|H5N8|EPI_ISL_1239109
> - protein file poor format, do not know which segment, tried to redownload and the same 
> interesting, they are N8 BUT are quiet different at the end of the sequence ... reassortment / cropping and parsing another segment ? 
#interesting #ask #bjørn 

Protein Accession no. | Gene name | Isolate name | Isolate ID | Type  -> its because I messed up the file format 
- so added the two sequences - cropped in frame . We need to re.sanatize because mega is like that 

```shell 
conda activatge seqkit 
seqkit seq -g -o NA_representative_inframe_sanitized.fasta NA_representative_inframe.fasta 

```
 
## Mulitple alignment with jalview 

```shell 
conda activate jalview 
jalview 
# use NA_representative_inframe_sanitized.fasta
# muscle - protein with preset 
```
ok, this alignment is not too nice ...
- we have 4 sequences that are too short 
- sort by pairwise identity 
- so I rechecked the cutting . this is fine ...
- Sorted sequences by jalview NJ tree 
==So multiple alignment large distance between H5N1 and H5N5 -> they will likely have to be done separately== ok -

# NP
- cropping to frame - folder: genotypes_data>wrangled>references_new_headers 
	- megaX for cropping in frame 
	- file: _cropped_NP_ref_newheader.mas
	- export : NP_nuc_protein_non_aligned.fas
- Interesting this one was not too variable start and end 
- 
# PB2
- cropping to frame - folder: genotypes_data>wrangled>references_new_headers 
	- megaX for cropping in frame 
	- file: _cropped_PB2_ref_newheader.mas
	- export : PB2_nuc_protein_non_aligned.fas
-  quiet homogenous also 
# PB1
- cropping to frame - folder: genotypes_data>wrangled>references_new_headers 
	- megaX for cropping in frame 
	- file: _cropped_PB1_ref_newheader.mas
	- export : PB1_nuc_protein_non_aligned.fas
- quiet homogenous also 
# PA
- cropping to frame - folder: genotypes_data>wrangled>references_new_headers 
	- megaX for cropping in frame 
	- file: _cropped_PA_ref_newheader.mas
	- export : PA_nuc_protein_non_aligned.fas

---
- [ ] to do - those two last have to proteins so a bit more challenging 
- [ ] 
# NS 
We need to find out how to get NEP - seems to be inframe but there is a shift 
2 proteins - NS - NEP/NS2 - see if overlapping frame 
- cropping to frame - folder: genotypes_data>wrangled>references_new_headers 
	- megaX for cropping in frame 
	- file: _cropped_NS_ref_newheader.mas
	- export : NS_nuc_protein_non_aligned.fas


# MP
2 proteins - MP1 -MP2 - see if overlapping frame 
- cropping to frame - folder: genotypes_data>wrangled>references_new_headers 
	- megaX for cropping in frame 
	- file: _cropped_MP_ref_newheader.mas
	- export : MP_nuc_protein_non_aligned.fas

---
date:: 2023-10-25
## grouping references and representative to use to create frame references for AI_pilot 

```shell 
# HA (48 + 66 ) 114 
cat HA_frame_non_alinged_sanitized_references.fasta HA_representative_inframe.fasta > HA_repr_ref_inframe.fasta 
# NA  - 113 total 
cat NA_frame_non_alinged_sanitized_references.fasta NA_representative_inframe_sanitized.fasta > NA_repr_ref_inframe.fasta 
```


---
---


see [[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/notes/2023-11-08_Papers_GISAID_external_data|2023-11-08_Papers_GISAID_external_data]]
see [[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/notes/old/2023-11-08_summary_paper_datasets|2023-11-08_summary_paper_datasets]]
see [[Projects/2023/1_AvianInfluenza/WTE_AI_article/logs_reorganized/2023-11-08_NVI_data_prep_papers|2023-11-08_NVI_data_prep_papers]]
see [[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/notes/2023-10-24_AI_Pilot_method_writing|2023-10-24_AI_Pilot_method_writing]]
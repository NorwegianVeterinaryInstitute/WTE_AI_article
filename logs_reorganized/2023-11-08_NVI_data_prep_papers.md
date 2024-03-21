# NVI dataset - first set

->  so H5N5 is not in dataset 2_ok BUT H5N1 is 

<!--
# NVI dataset 1 - in frame 

redone because now better reference 
> # HA and NA segments - NVI data - In frame cropping - to redo ? because better refs now ?  
#### HA
- using vsearch to crop detect the frame - use the ref_repr_genotypes dataset -> then check in MEGA and in the tsv file from vsearch that shows the matches 
```
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/data/inframe_cropping/HA/H5N1

conda activate vsearch

vsearch  --db ../HA_repr_ref_inframe.fasta -- busearch_global HA_H5N1_NVI_SEP.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N1_NVI_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 --alnout HA_H5N1_NVI_SEP_alignment.aln \
--fastapairs HA_H5N1_NVI_SEP_fastapairs.fasta \
--matched HA_H5N1_NVI_SEP_matched.fasta \
--notmatched HA_H5N1_NVI_SEP_notmatched.fasta \
--log HA_H5N1_NVI_SEP_vsearch.log  --notrunclabels 
```

 - [ x] filtering identical sequences - when in frame  - no point to have too huge tree 
 - [ x} ? make a header that is common for all the samples ? so we can trace back identical samples ? THINK 
 - [x] ? do we need to reorient ? or can this be done also automatically if there is the need 

-->
 - [  ]  ==I need to do the rooting with the goose from Guandong - so add it to the dataset ==
- [   ] ==HA gene  - H5N5 and H5N1 together for HA ? ==



# Reformatting  - cleaning - NVI data 
### removing gaps for all consensus sequences 
- [x] rechecking I have all the consensus files before doing that
- [x] Consensus contain gaps - because consensus done by mapping in insaflu - they need to be removed 
consensus sequences contain gaps because obtained by mapping from INSaFLU
```
cd 12302_Avian_influenza_2023/data/artic_consensus/H5N1
# done for all consensus H1N1 and H5N5 for SEP and AP 

conda activate seqkit 
for file in $(ls *.fasta) 
do 
seqkit seq -g -o sanitized/${file} ${file}
done 
# same in other folders for artic and sea eagle 
```

---

# Reformatting fasta headers - NVI for each strain type and paper 

The reformating of fasta headers, is done in the same order as I have downloaded on GISAID : `Isolate name | Segment | Isolate ID`   so we can then use the python script I have made to separate all in individual files 
script:: [[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/reformat_NVI_headers.R|reformat_NVI_headers]]
- [x] verified that the segment numbering correspondance was correct using blast on one isolate I reformated as test
- [x] Then we extract the segments - and concatenate all the NVI samples - segments 
- [x] We do that per dataset H5N1 AND H5N5  AND per paper 

## AP - H5N1
```shell
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/reformat_NVI_headers.R"
PYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/split_fasta.py"
conda activate biopython 

Rscript $MYSCRIPT -h

# ARCTIC 
## H5N1 

cd 12302_Avian_influenza_2023/data/artic_consensus/H5N1 

### Reformating 
for file in $(ls sanitized/*.fasta) 
do 
Rscript $MYSCRIPT --sample $file --strain H5N1 --outdir reformated
done 

### concatenating all reformated 
cat reformated/*.fasta > AP_H5N1_NVI.fasta 
grep ">" AP_H5N1_NVI.fasta | wc -l #110 (would expect 112)

for file in $(ls reformated/*.fasta*) 
do 
grep ">" $file | wc -l
done 
# Consensus_2022_07_1772_1t.fasta only 6 segments  - so ok

### creating files per segment 
python $PYSCRIPT --fasta AP_H5N1_NVI.fasta --outdir segments 
# now I move all into separate folders 
# concatenate files per segment 
cat segments/HA*.fasta > HA_H5N1_NVI_AP.fasta
cat segments/NA*.fasta > NA_H5N1_NVI_AP.fasta
# 14 seq in both 
cat segments/NP*.fasta > NP_H5N1_NVI_AP.fasta
cat segments/MP*.fasta > MP_H5N1_NVI_AP.fasta
cat segments/PA*.fasta > PA_H5N1_NVI_AP.fasta
cat segments/PB1*.fasta > PB1_H5N1_NVI_AP.fasta
cat segments/PB2*.fasta > PB2_H5N1_NVI_AP.fasta
cat segments/NS*.fasta > NS_H5N1_NVI_AP.fasta
```

-  removing temporary files: 
- [x] consensus files - we wont use that anymore 
- [x] AP_H5N1_NVI.fasta 
- [x] reformated files 
- [x] sanitized files 
- [x] segments folder (all files in single segment)

----
## SEP H5N1
```shell
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/reformat_NVI_headers.R"
PYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/split_fasta.py"
conda activate biopython 

# SEA-EAGLE 
## H5N1
cd 2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/data/consensus_H5N1

### reformating 
for file in $(ls sanitized/*.fasta) 
do 
Rscript $MYSCRIPT --sample $file --strain H5N1 --outdir reformated
done 

### concatenating all reformated 
cat reformated/*.fasta > SEP_H5N1_NVI.fasta 
grep ">" SEP_H5N1_NVI.fasta  | wc -l #65 (would expect 72) - so some are incomplete 

### creating files per segment 
python $PYSCRIPT --fasta SEP_H5N1_NVI.fasta --outdir segments 

### concatenating each segment 
segt=( HA PB2 PB1 NS PA NP NA MP )

for each in ${segt[@]}
do 
cat segments/${each}*.fasta > ${each}_H5N1_NVI_SEP.fasta
done 
```
-  removing temporary files: 
- [x] consensus files - we wont use that anymore 
- [x] SEP_H5N1_NVI.fasta
- [x] reformated files 
- [x] sanitized files 
- [x] segments folder (all files in single segment)

----
## SEP H5N5
```shell 
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/reformat_NVI_headers.R"
PYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/split_fasta.py"
conda activate biopython 

# SEA-EAGLE 
## H5N5
cd 2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/data/consensus_H5N5

### reformating 
for file in $(ls sanitized/*.fasta) 
do 
Rscript $MYSCRIPT --sample $file --strain H5N5 --outdir reformated
done 

### concatenating all reformated 
cat reformated/*.fasta > SEP_H5N5_NVI.fasta 
grep ">" SEP_H5N5_NVI.fasta  | wc -l # 83 (would expect 96) 

### creating files per segment 
python $PYSCRIPT --fasta SEP_H5N5_NVI.fasta --outdir segments 

### concatenating each segment 
segt=( HA PB2 PB1 NS PA NP NA MP )

for each in ${segt[@]}
do 
cat segments/${each}*.fasta > ${each}_H5N5_NVI_SEP.fasta
done 
```

-  removing temporary files: 
- [x] consensus files - we wont use that anymore 
- [x] SEP_H5N5_NVI.fasta
- [x] reformated files 
- [x] sanitized files 
- [x] segments folder (all files in single segment)


----

# NVI dataset - second set - data2 - new sequences 
date:: 2023-11-08 - Catherine is adding sequences in insaflu - and is now ready to add to the dataset

see [[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/notes/2023-11-03_meeting|2023-11-03_meeting]] - Meeting 2023-11-03 With Cathrine to go through that - need to add more isolates to the dataset 
Posted in teams.   


## Checklist :

See lists in `SEP_NVI_seq_info.xlsx` and `AP_NVI_seq_info.xlsx`
### AP - H5N5  

not found in GISAID 2023-11-08 - ask Cathrine - if are in the dataset she gave me 
- [ ] A/northern_goshawk/Norway/2023_07_184/2023 
- [ ] A/great_black-backed_gull/Norway/2022_07_3018_2/2022


- [x] references used for  insaflu typing from cathrine - no H5N5 used as reference as far as I know - ask if set reference updated 

downloaded or have 
- [x] A/sea_eagle/Norway/2022-07-100_22VIR2882-2/2022 -> 2022_07_100c ? (this is included  but short HA)  add to Arctic also  EPI_ISL_12028892  
- [x] Canadian sequence : WIN-AH-2023-FAV-0035-6-h5n5.fasta 
- [x] All additional from Cath 
### AP & SEP -  H5N1  in both 
- [ ] a Black-legged-Kittiwake-2023 Harstad =? A_H5N1_Blacklegged_kittiwake_Harstad_650_2_2023 H5N1 
used as reference 

 - [ ] references used for  insaflu typing from cathrine 
	 - [x] EPI_ISL_1254 -  A_H5N1_A_Goose_Guangdong_1_1996
	 - [x] EPI_ISL_177506 A_H5N1_A_chicken_Egypt_A10351A_2014
	 - [x] EPI_ISL_603133 A_H5N1_EurasionWigeon/Netherlands/2020-1


### SEP + AP - H5N5  inboth papers 

Those uploaded from Cath to GISAID 
- [x] A/Great_black-backed_gull/Norway/2022-07-1141-4T/2022|EPI_ISL_18455201|H5N5|
- [x] A/European_herring_gull/Norway/2022-07-1141-1T/2022|EPI_ISL_18455200|H5N5|
- [x] A/Glaucous_gull/Norway/2022-07-1148/2022|EPI_ISL_18454937|H5N5|
- [x] All additional from Cath 
 - [x] references used for  insaflu typing from cathrine - 
	 - [x] EPI_ISL_12754536 - eagle reference h5n5
ok 
### SEP + AP H5N5 in both ... 
- [x] references used for  insaflu typing from cathrine 

downloaded 
- [x] A/Northern_gannet/Norway/2022-07-1146-1T/2022  EPI_ISL_18455202 H5N1 
- [x] A/Red_fox/Norway/2022-07-1768-2T/2022|EPI_ISL_18455203|H5N1| 
 

---



# Preparing reformatting dataset 2 - SEP only (priority) 

- [x] added all new NVI H5N1 and H5N5 in different folders 
- [x] added all external H5N1 and H5N5 in different folders  
So total 4 folders to wrapping - different formats in the beginning 

## Reformating NVI data 2 - SEP  H5N1

- [x] removing gaps for all consensus sequences  (consensus sequences contain gaps because obtained by mapping from INSaFLU - and there is some padding with N/n )
```shell
# removing gaps and Ns
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2/H5N1_NVI
conda activate seqkit 
mkdir sanitized

for file in $(ls original/*.fasta) 
do 
id=$(echo $file | sed -e "s#original/##") 
seqkit seq -g -G "- N n " -o sanitized/${id} ${file}
done 

ls sanitized/*.fasta | wc -l #56

```

- [x] reformating headers so is same format as gisaid and extracting segments 
Rscript:: `reformat_NVI_headers.R


```shell 
myscript="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/reformat_NVI_headers.R"

mkdir reformated 

for file in $(ls sanitized/*.fasta) 
do 
id=$(echo $file | sed -e "s#sanitized/##") 
Rscript $myscript --sample sanitized/${id} --strain H5N1 --outdir reformated 
done 

# Concatenating all reformated  
cat reformated/*.fasta > SEP_H5N1_NVI2.fasta 
```

- [x] creating files per segments 
```shell
# creating files per segments 
PYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/split_fasta.py"
conda activate biopython 

mkdir segments 
python $PYSCRIPT --fasta SEP_H5N1_NVI2.fasta  --outdir segments 
```

- [x] concatenating per segments 
```shell 
# concatenating each segments 
segt=( HA PB2 PB1 NS PA NP NA MP )

for each in ${segt[@]}
do 
cat segments/${each}*.fasta > ${each}_H5N1_NVI2_SEP.fasta
done 

grep ">" HA_H5N1_NVI2_SEP.fasta | wc -l
#49
```

- [x] removing temporary files 

-----
## Reformating NVI data 2 - SEP - H5N5
- [x] removing gaps and Ns
```sheel
# removing gaps and Ns
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2/H5N5_NVI

mkdir sanitized 

conda activate seqkit 

for file in $(ls original/*.fasta) 
do 
id=$(echo $file | sed -e "s#original/##") 
seqkit seq -g -G "- N n " -o sanitized/${id} ${file}
done 
```


- [x] reformating headers so is same format as gisaid and extracting segments 
Rscript:: `reformat_NVI_headers.R


```shell 
myscript="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/reformat_NVI_headers.R"

mkdir reformated 

for file in $(ls sanitized/*.fasta) 
do 
id=$(echo $file | sed -e "s#sanitized/##") 
Rscript $myscript --sample sanitized/${id} --strain H5N5 --outdir reformated 
done 

# Concatenating all reformated  
cat reformated/*.fasta > SEP_H5N5_NVI2.fasta 
```

- [x] creating files per segments 
```shell
# creating files per segments 
PYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/split_fasta.py"
conda activate biopython 

mkdir segments 
python $PYSCRIPT --fasta SEP_H5N5_NVI2.fasta  --outdir segments 
```

- [x] concatenating per segments 
```shell 
# concatenating each segments 
segt=( HA PB2 PB1 NS PA NP NA MP )

for each in ${segt[@]}
do 
cat segments/${each}*.fasta > ${each}_H5N5_NVI2_SEP.fasta
done 

grep ">" HA_H5N5_NVI2_SEP.fasta | wc -l
#49
```

- [x] removing temporary files 

## Reformating external data 2 - SEP - H5N1

- [x] removing gaps for all consensus sequences  (consensus sequences contain gaps because obtained by mapping from INSaFLU - and there is some padding with N/n )
```shell
# removing gaps and Ns
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2/H5N1_external
mkdir sanitized

conda activate seqkit 

for file in $(ls original/*.fasta) 
do 
id=$(echo $file | sed -e "s#original/##")
seqkit seq -g -G "- N n " -o sanitized/${id} ${file}
done 

```

```shell 
# Concatenating all 
cat sanitized/*.fasta > SEP_H5N1_GISAID2.fasta 
```

- [x] creating files per segments 
```shell
# creating files per segments 
PYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/split_fasta.py"
conda activate biopython 

mkdir segments 
python $PYSCRIPT --fasta SEP_H5N1_GISAID2.fasta   --outdir segments 
```

- [x] concatenating per segments 
```shell 
# concatenating each segments 
segt=( HA PB2 PB1 NS PA NP NA MP )

for each in ${segt[@]}
do 
cat segments/${each}*.fasta > ${each}_H5N1_GISAID2_SEP.fasta
done 

grep ">" HA_H5N1_GISAID2_SEP.fasta | wc -l

```

- [x] removing temporary files 

## Reformating external data 2 - SEP - H5N5
- [x] removing gaps and Ns
```sheel
# removing gaps and Ns
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2/H5N5_external

conda activate seqkit 
mkdir sanitized

for file in $(ls original/*.fasta) 
do 
id=$(echo $file | sed -e "s#original/##")
seqkit seq -g -G "- N n " -o sanitized/${id} ${file}
done 

```


```shell 
# Concatenating all   
cat sanitized/*.fasta > SEP_H5N5_GISAID2.fasta 
```

- [x] creating files per segments 
```shell
# creating files per segments 
PYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/split_fasta.py"
conda activate biopython 

mkdir segments 
python $PYSCRIPT --fasta SEP_H5N5_GISAID2.fasta  --outdir segments 
```

- [x] concatenating per segments 
```shell 
# concatenating each segments 
segt=( HA PB2 PB1 NS PA NP NA MP )

for each in ${segt[@]}
do 
cat segments/${each}*.fasta > ${each}_H5N5_GISAID2_SEP.fasta
done 
```

- [x] removing temporary files 
---



---
# In Frame NVI data2 (Discarded because was missing some sequences  - So I have to redo the whole process) 

using updated HA and NA references for cropping `HA_repr_ref_inframe_extended.fasta` and `NA_repr_ref_inframe_extended.fasta`

```shell 
uprefdir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/updated_references"

HAref=$uprefdir/"HA_repr_ref_inframe_extended.fasta"
NAref=$uprefdir/"NA_repr_ref_inframe_extended.fasta"
```


## HA - H5N1 -SEP 


```shell 
cd 112302_Avian_influenza_2023/data/sea_eagle_consensus/data_2/H5N1_external/segments

mkdir HA_inframe && cd HA_inframe 

conda activate vsearch 
vsearch  --db ${HAref} --usearch_global ../HA_H5N1_NVI2_SEP.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N1_NVI2_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N1_NVI2_SEP_alignment.aln \
--fastapairs HA_H5N1_NVI2_SEP_fastapairs.fasta \
--matched HA_H5N1_NVI2_SEP_matched.fasta \
--notmatched HA_H5N1_NVI2_SEP_notmatched.fasta \
--log HA_H5N1_NVI2_SEP_vsearch.log  --notrunclabels 

# Matching unique query sequences: 48 of 49 (97.96%) 
```

- [x] checking non matched 
	- [x] 2022_07_1142_1_H5N1|HA|2022_07_1142_1  -> adding manually to the references - updated 
		- [x] This is a partial sequence ... (I had removed the sea eagle but then need to read)
		- [ ] refreshing the reference 

```
seqkit seq -gl -o HA_repr_ref_inframe_extended.fasta HA_repr_ref_inframe_extended.fas 
```
relaunching round to see if get all - now 100 %

- [x] checking tsv 

----
## NA - H5N1 - SEP 
- now getting the dataset 

```shell 
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2/H5N1_NVI/segments/final_inframe

MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment ../HA_inframe/HA_H5N1_NVI2_SEP_fastapairs.fasta --output HA_H5N1_NVI2_SEP_inframe.fasta 

grep ">"  HA_H5N1_NVI2_SEP_inframe.fasta  | wc -l #56

```



```shell 
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2/H5N1_NVI/segments

mkdir NA_inframe && cd NA_inframe 


uprefdir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/updated_references"
HAref=$uprefdir/"HA_repr_ref_inframe_extended.fasta"
NAref=$uprefdir/"NA_repr_ref_inframe_extended.fasta"


conda activate vsearch 
vsearch  --db ${NAref} --usearch_global ../NA_H5N1_NVI2_SEP.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N1_NVI2_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N1_NVI2_SEP_alignment.aln \
--fastapairs NA_H5N1_NVI2_SEP_fastapairs.fasta \
--matched NA_H5N1_NVI2_SEP_matched.fasta \
--notmatched NA_H5N1_NVI2_SEP_notmatched.fasta \
--log NA_H5N1_NVI2_SEP_vsearch.log  --notrunclabels 

#100% 
```

- [x] checking non matched 0
- [x] checking tsv 

getting final dataset 
```shell 
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2/H5N1_NVI/segments/final_inframe

MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"

Rscript $MYSCRIPT --alignment ../NA_inframe/NA_H5N1_NVI2_SEP_fastapairs.fasta --output NA_H5N1_NVI2_SEP_inframe.fasta 

grep ">"  NA_H5N1_NVI2_SEP_inframe.fasta  | wc -l # 56

```

----
## HA - H5N5 - SEP


```shell 
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2/H5N5_NVI/segments

mkdir HA_inframe && cd HA_inframe 

uprefdir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/updated_references"
HAref=$uprefdir/"HA_repr_ref_inframe_extended.fasta"
NAref=$uprefdir/"NA_repr_ref_inframe_extended.fasta"

conda activate vsearch 
vsearch  --db ${HAref} --usearch_global ../HA_H5N5_NVI2_SEP.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N5_NVI2_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N5_NVI2_SEP_alignment.aln \
--fastapairs HA_H5N5_NVI2_SEP_fastapairs.fasta \
--matched HA_H5N5_NVI2_SEP_matched.fasta \
--notmatched HA_H5N5_NVI2_SEP_notmatched.fasta \
--log HA_H5N5_NVI2_SEP_vsearch.log  --notrunclabels 

#100 %
```


```shell 
mkdir final_inframe && cd final_inframe 

MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"

Rscript $MYSCRIPT --alignment ../HA_inframe/HA_H5N5_NVI2_SEP_fastapairs.fasta --output HA_H5N5_NVI2_SEP_inframe.fasta 

grep ">"  HA_H5N5_NVI2_SEP_inframe.fasta  | wc -l #11 
```

----
## NA - H5N5 - SEP

```shell 
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2/H5N5_NVI/segments

mkdir NA_inframe && cd NA_inframe 


uprefdir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/updated_references"
HAref=$uprefdir/"HA_repr_ref_inframe_extended.fasta"
NAref=$uprefdir/"NA_repr_ref_inframe_extended.fasta"


conda activate vsearch 
vsearch  --db ${NAref} --usearch_global ../NA_H5N5_NVI2_SEP.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N5_NVI2_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N5_NVI2_SEP_alignment.aln \
--fastapairs NA_H5N5_NVI2_SEP_fastapairs.fasta \
--matched NA_H5N5_NVI2_SEP_matched.fasta \
--notmatched NA_H5N5_NVI2_SEP_notmatched.fasta \
--log NA_H5N5_NVI2_SEP_vsearch.log  --notrunclabels 

#100 %
```


```shell 
mkdir final_inframe && cd final_inframe 

MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"

Rscript $MYSCRIPT --alignment ../NA_inframe/NA_H5N5_NVI2_SEP_fastapairs.fasta --output NA_H5N5_NVI2_SEP_inframe.fasta 

grep ">"  NA_H5N5_NVI2_SEP_inframe.fasta  | wc -l #11 
```

---- 

# SEP - In Frame GISAID data2 
## HA - H5N1


```shell 

uprefdir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/updated_references"
HAref=$uprefdir/"HA_repr_ref_inframe_extended.fasta"
NAref=$uprefdir/"NA_repr_ref_inframe_extended.fasta"


mkdir HA_inframe && cd HA_inframe 

# round 1
conda activate vsearch 
vsearch  --db ${HAref} --usearch_global ../HA_H5N1_GISAID2_SEP.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N1_GISAID2_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N1_GISAID2_SEP_alignment.aln \
--fastapairs HA_H5N1_GISAID2_SEP_fastapairs.fasta \
--matched HA_H5N1_GISAID2_SEP_matched.fasta \
--notmatched HA_H5N1_GISAID2_SEP_notmatched.fasta \
--log HA_H5N1_GISAID2_SEP_vsearch.log  --notrunclabels 

# Matching unique query sequences: 3 of 5 (60.00%)
 
```

- its because I have mapping reference that are too different , so I need to add those to the references and rerun 
Adding to the reference files , and exporting and sanitizing 

```shell
conda activate seqkit
seqkit seq -gl -o HA_repr_ref_inframe_extended.fasta HA_repr_ref_inframe_extended.fas 
```
- round 2 relaunch command 
	- ok - match all 


```shell
cd ..
mkdir final_inframe && cd final_inframe 


MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment ../HA_inframe/HA_H5N1_GISAID2_SEP_fastapairs.fasta --output HA_H5N1_GISAID2_SEP_inframe.fasta 

grep ">"  HA_H5N1_GISAID2_SEP_inframe.fasta  | wc -l #5 
```

-----
## NA - H5N1


```shell
uprefdir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/updated_references"
HAref=$uprefdir/"HA_repr_ref_inframe_extended.fasta"
NAref=$uprefdir/"NA_repr_ref_inframe_extended.fasta"


mkdir NA_inframe && cd NA_inframe 

# round 1
conda activate vsearch 
vsearch  --db ${NAref} --usearch_global ../NA_H5N1_GISAID2_SEP.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N1_GISAID2_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N1_GISAID2_SEP_alignment.aln \
--fastapairs NA_H5N1_GISAID2_SEP_fastapairs.fasta \
--matched NA_H5N1_GISAID2_SEP_matched.fasta \
--notmatched NA_H5N1_GISAID2_SEP_notmatched.fasta \
--log NA_H5N1_GISAID2_SEP_vsearch.log  --notrunclabels 

```
- also missing 2 sequences - updating references - alignment in mega

```shell 
conda activate seqkit
seqkit seq -gl -o NA_repr_ref_inframe_extended.fasta NA_repr_ref_inframe_extended.fas 
```

round 2 - relaunch command 
- all matched 
- ok now 

 
```shell
cd final_inframe 


MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment ../NA_inframe/NA_H5N1_GISAID2_SEP_fastapairs.fasta --output NA_H5N1_GISAID2_SEP_inframe.fasta 

grep ">"  NA_H5N1_GISAID2_SEP_inframe.fasta  | wc -l #5 

```

----

## HA - H5N5 

```shell
uprefdir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/updated_references"
HAref=$uprefdir/"HA_repr_ref_inframe_extended.fasta"
NAref=$uprefdir/"NA_repr_ref_inframe_extended.fasta"


mkdir HA_inframe && cd HA_inframe 

conda activate vsearch 
vsearch  --db ${HAref} --usearch_global ../HA_H5N5_GISAID2_SEP.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N5_GISAID2_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N5_GISAID2_SEP_alignment.aln \
--fastapairs HA_H5N5_GISAID2_SEP_fastapairs.fasta \
--matched HA_H5N5_GISAID2_SEP_matched.fasta \
--notmatched HA_H5N5_GISAID2_SEP_notmatched.fasta \
--log HA_H5N5_GISAID2_SEP_vsearch.log  --notrunclabels 

# 4 all in 

# check tsv ok 

cd ..

mkdir final_inframe && cd final_inframe 


MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment ../HA_inframe/HA_H5N5_GISAID2_SEP_fastapairs.fasta --output HA_H5N5_GISAID2_SEP_inframe.fasta 

grep ">"  HA_H5N5_GISAID2_SEP_inframe.fasta  | wc -l 


```

----
## NA - H5N1 

```shell 
uprefdir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/updated_references"
HAref=$uprefdir/"HA_repr_ref_inframe_extended.fasta"
NAref=$uprefdir/"NA_repr_ref_inframe_extended.fasta"


mkdir NA_inframe && cd NA_inframe 

conda activate vsearch 
vsearch  --db ${NAref} --usearch_global ../NA_H5N5_GISAID2_SEP.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N5_GISAID2_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N5_GISAID2_SEP_alignment.aln \
--fastapairs NA_H5N5_GISAID2_SEP_fastapairs.fasta \
--matched NA_H5N5_GISAID2_SEP_matched.fasta \
--notmatched NA_H5N5_GISAID2_SEP_notmatched.fasta \
--log NA_H5N5_GISAID2_SEP_vsearch.log  --notrunclabels 

# 4 all in 

# check tsv ok 

cd ../final_inframe 


MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment ../NA_inframe/NA_H5N5_GISAID2_SEP_fastapairs.fasta --output NA_H5N5_GISAID2_SEP_inframe.fasta 

grep ">"  NA_H5N5_GISAID2_SEP_inframe.fasta  | wc -l # 4




```


----
# SEP  In Frame NVI data2_ok 
In Data2 only the external files are usable 

script:: `wrapping_wrangling_code.sh`

- made a wrapper script to do that - first one is testing - H5N1 for SEP 
## H5N1
```shell 

 cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2_ok/H5N1

# sourcing script 
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"wrapping_wrangling_code.sh"
# renaming original files  - removes Consensus 
rename_files_fun
# removes gaps and Ns 
remove_gaps_fun 
# reformat headers to be consistent with gisad data 
reformating_NVI_headers_fun 
# concatenating all refromated 
concat_reformated_fun 
# separating files per semgments 
create_segments_files_fun 
# concatenating all the segments 
concatenate_segments_files_fun
# creating inf frame 
vsearch_inframe_fun 
# check its ok THEN 
# extracting the inframe segments
final_inframe_fun 
# removing intermediary folders and files 
reorganize_directory_fun

# ok it works so I can write the wrapper - specific to NVI data 
```


## H5N5

The data have to be in original folder  - yes it works perfectly now !
```shell 
MY_MAINDIR="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2_ok/H5N5"
MY_STRAIN="H5N5"
MY_ARTICLE="SEP"
MY_DATASET="NVI2"
MY_INFRAME_SEGTS_ARRAY=( "HA" "NA" )

codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"wrapping_wrangling_code.sh"

wrapper_run_fun_NVI

```

---




---
# Checklist dataset SEP  - FINAL Dataset SEP 

==Updated summary `SEP_NVI_seq_info.xlsx` final dataset tab==

Testing order removal duplicates by seqkit. 
- by name 
- by sequence 

```shell 
conda activate seqkit 
seqkit rmdup --help # normally only first record will be saved (ok so output first one found )
# by name 
seqkit rmdup -n dummy.fasta 
# by seq 
seqkit rmdup -s dummy.fasta # keeps also first one 
# cat add at tge end of file 
```

so order concatenating 
- dataset 2 - we want to keep the most recents in case of duplicates 
- dataset 1
- remove duplicates by names (check by sequence) 

```shell 
cd 12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep 
```

----

# FINAL - SEP - HA - H5N1
recheck & redone 2023-11-15 0

- [x] ==remove the mapping references from dataset 2 gisad == than are not sea eagle good and egypt chikken  - because want this one included 
	- [x] A_H5N1_A_Goose_Guangdong_1_1996  = EPI_ISL_1254
	- [x] pasted in SEP_H5N1_ref_HA.fasta

Now concatenating files - Those to use in final  analyses start by SEP 
- [ ] NVI data2 + NVI data1 (order important for check duplicates) + GISAID2 The ones we really want to be included and matched for comparison 
```shell

codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"


SEP_DIR="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep" 

cd ${SEP_DIR}/HA/H5N1
cat inframe/HA_H5N1_NVI2_SEP_inframe.fasta inframe/HA_H5N1_NVI_SEP.fasta >  temp.fasta 

# rechecking formatting is correct 
remove_gaps_check_fun temp.fasta 
# remove eventual duplicates 
## by name 
conda activate seqkit
seqkit rmdup -n temp.fasta > SEP_H5N1_NVI_nodub_HA.fasta # remove was no duplicates by name % 8 duplicates removed 
## check duplicates by sequence but do not remove 
mkdir -p donotuse
seqkit rmdup -si SEP_H5N1_NVI_nodub_HA.fasta  -D donotuse/SEP_H5N1_NVI_dup >  donotuse/test_SEP_H5N1_NVI_nodupseq.fasta # 8 duplicated sequences - inspection  removed 
# clean temporary file 
rm temp.fasta 

# rechecchecking if 
```


- [x] now checking for duplicates in the file - for those that are real - the other are not identical but not duplicates - its ok 
	- [x] 2021_07_3217_1_H5N1|HA|2021_07_3217_1 ==  2021_07_3217_1K_H5N1|HA|2021_07_3217_1K, remove last one manually from final file 

We just keep the first  one and remove the other ... manually 
-> Final File NVI is `SEP_H5N1_NVI_nodub_HA.fasta`  (67 sequences)


```shell 
# checking sanitizing gisaid sequences 

codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"
# cp files from inframe 
remove_gaps_check_fun HA_H5N1_GISAID_SEP_inframe.fasta
remove_gaps_check_fun HA_H5N1_GISAID2_SEP_inframe.fasta
remove_gaps_check_fun SEP_H5N1_ref_HA.fasta



```

- too many sequences - and they are all quiet related -  ... how do we deal with that? 
No, we keep Gisaid 2 and NVI for analyses 
but we reduce size of gistaid 1 because too many to use for a phylogenetic tree - we use vsearch to find the isolates from which its that are suitable to compare to  
FINAL FILE _H5N1 _12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/HA/H5N1

Filtering out gisad 2 data - choose iddef 3 so it favors differences and that gap opening count as one (so favors abit longer sequences if many sequences - use iddef 0.96 as a start 
use db is NVI data 
```
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"

# vsearch_filter_fun  $DB $fileto filter $id $prefix for outfile 
vsearch_filter_fun SEP_H5N1_NVI_nodub_HA.fasta HA_H5N1_GISAID_SEP_inframe.fasta 0.96 HA_H5N1_GISAID_SEP_filtered_inframe

# first trial 5272 is too many - increase id - 
vsearch_filter_fun SEP_H5N1_NVI_nodub_HA.fasta HA_H5N1_GISAID_SEP_inframe.fasta 0.98 HA_H5N1_GISAID_SEP_filtered_inframe
# 5259 its still too many - but might be a lot of identica l

# increase to 0.99 
vsearch_filter_fun SEP_H5N1_NVI_nodub_HA.fasta HA_H5N1_GISAID_SEP_inframe.fasta 0.99 HA_H5N1_GISAID_SEP_filtered_inframe
```

hum, not sure if that worse to filter here ... forget that for now, too many that are likely the same 

Concatenating files for phylogenetic tree H5N1 `cat *.fasta  > H5N1_all_SEP.fasta` posed a problem - finding out what is wrong 
 
```shell 
# I had concatenated files but there is a problem after of format so checking step by step 
#so problem beause seems weirds caracters ... probably mix because done with windows stuudd 
seqkit sana -i fasta -t dna SEP_H5N1_ref_HA.fasta -o dummy > seqkit.sana.log  # Ok this one is ok 
seqkit sana -i fasta -t dna SEP_H5N1_NVI_nodub_HA.fasta -o dummy > seqkit.sana.log  # ok this one is ok 
seqkit sana -i fasta -t dna HA_H5N1_GISAID2_SEP_inframe.fasta -o dummy > seqkit.sana.log # ok this one is ok 
seqkit sana -i fasta -t dna HA_H5N1_GISAID_SEP_inframe.fasta -o dummy > seqkit.sana.log 

# trying to remove special characters in case to be sure 
 sed -i 's/\r//' SEP_H5N1_ref_HA.fasta
 sed -i 's/\r//' SEP_H5N1_NVI_nodub_HA.fasta
 sed -i 's/\r//' HA_H5N1_GISAID2_SEP_inframe.fasta
 sed -i 's/\r//' HA_H5N1_GISAID_SEP_inframe.fasta
 # rerun so the invalid line structure arrize as concatenation 
cat *.fasta  > H5N1_all_SEP.fasta
seqkit sana -i fasta -t dna  H5N1_all_SEP.fasta -o dummy > seqkit.sana.log 
# alterantive compcatenation ! This works - because now put a space beween files 
sed -e '$s/$/\n/' -s *.fasta >  H5N1_all_SEP.fasta # 5512 sequecnes 


# checking removing gaps a last time 
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"
remove_gaps_check_fun H5N1_all_SEP.fasta 
# rechecked and still ok with seqkit 
```

! carrefull concatenation 
## Trying MSA  --- Javlivew (too many sequences ) - MACSE - (did not finish)  
Creating multiple alignment - jalview  online not possible: too many sequences  - we could try to use the defaults in muscles  - added to `muscle_defaults.jalview`
or we can try MACSE now that they are cropped in frame for simplicity 

```shell 
conda activate macse 
macse (alignemnt using defaults)

#conda activate muscle 
#muscle -super5 input.fa -output aln.afa
```

- so 5511 sequences with genetic code -> we need to see if it keeps all or not and align the other ones we do not want after 
- I think MACSE will be too slow ... 
- ok, we vcan try that: check mafft -> aligned using mafft adding to existing alignmen 

---- 
## preparing a Reference MSA for mafft 
- trying MSA by using a reference alignment (H5 sequences) and then using mafft to add those sequences to the alignment and then remove the initial alignment sequences. 

1. reformating the original references files to I can use to make an initial  reference MSA, using R script (add text front header so its easier to crop afterwards) `for_initial_alignment_reformat_ref.R`
2. Cleaning the references files - there are still some Ns I spoted that: 

- There are still N in the reference files  and gaps - remove 
```shell 
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"
#SEP_DIR="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep" 

cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/HA/H5N1/msa
# rechecking formatting is correct 
remove_gaps_check_fun for_initial_MSA_HA_repr_ref_inframe_extended.fasta
```

3. Edit in that are not H5 from the dataset - and partial sequences  (did that in Mega)
remove the gaps - again 

```
remove_gaps_check_fun H5N1_initial_ref.fasta
```
4. Multiple alignment in Javlivew (muscle proteins with preset) 
5. Inspection of multiple alignment - ok not plenty of gaps now - size 1710 !  

----
## Filtering the large external dataset 
- Filtering external large gistaid dataset 
- [x] remove short sequences ->  if inf  1700 - remove  sequence - we want quiet good sequences to compare with -> 5313 sequences (`Rscript : **seq_length_filter.R**)
- [x] filter by id to our sequences - that we want to use - vsearch - iddef3 0.98 -> increased to 0.99

```shell
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/HA/H5N1/filtering_gisaid1

codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"

vsearch_filter_fun ../SEP_H5N1_NVI_nodub_HA.fasta HA_H5N1_GISAID_SEP_inframe_length_filtered.fasta 0.98 HA_H5N1_GISAID_SEP_inframe_filtered_iddef3_098.fasta 
# result sequences - 5150
**vsearch_filter_fun ../SEP_H5N1_NVI_nodub_HA.fasta HA_H5N1_GISAID_SEP_inframe_length_filtered.fasta 0.99 HA_H5N1_GISAID_SEP_inframe_filtered_iddef3_99.fasta**
# results sequences - 4831**
```

-> we keep that - so we remove the duplicate files with seqkit from the matched sequences 
- [x] per name first - to see if sufficient - no
- [x] per sequence 
```shell

codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"

cp vsearch_filter/HA_H5N1_GISAID_SEP_inframe_filtered_iddef3_99.fasta_matched.fasta .

# per name 
remove_duplicates_name_fun HA_H5N1_GISAID_SEP_inframe_filtered_iddef3_99.fasta_matched.fasta # 0 duplicated records removed - 4831
# so ok was not per name - remove duplicates per sequence 
remove_duplicates_seq_fun HA_H5N1_GISAID_SEP_inframe_filtered_iddef3_99.fasta_matched.fasta # no duplicate either ... interesting but weird considering the amount of data 
```


--- 
## Concatenating datasets 
- adding also the reference from china 
```
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/HA/H5N1/msa

sed -e '$s/$/\n/' -s dataset_for_concat/*.fasta > SEP_HA_H5N1_clean_total_dataset.fasta # 4903
```

----
## MSA completing - with mafft 
https://mafft.cbrc.jp/alignment/software/manual/manual.html old ... 
https://mafft.cbrc.jp/alignment/server/index.html 
```
**mafft** **_input_ > _output_**
#There are 240 ambiguous characters.

mafft --maxiterate 5 --add SEP_HA_H5N1_clean_total_dataset.fasta H5N1_initial_ref_MSA_jalview.fasta > SEP_HA_H5N1_MSA0.fasta


```


-----

## removing the MSA guide from MSA 
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/HA/H5N1/msa
- using script R `remove_initial_alignment_from_MSA.R`
seems there is still some duplicate sequences 


```shell 
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"

# per name 
remove_duplicates_name_fun SEP_HA_H5N1_MSA_maxdata.fasta # 4902
```

---
## IQTREE 

```
cd iqtree_test1 
conda activate iqtree 

iqtree -s SEP_HA_H5N1_MSA_maxdata.fasta -m MFP+F+I  -B 1000 -T AUTO
```

----

# FINAL - SEP HA H5N5 - OK 
## Filtering / Concatenating  dataset 

- [ ] no mapping reference to remove as sea eagle we want to look at is a reference used for mapping 
- [ ] Concatenating files :  NVI data2 + NVI data1 (order important for check duplicates) + GISAID2 The ones we really want to be included and matched for comparison 
```shell
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"
SEP_DIR="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep" 

cd ${SEP_DIR}/HA/H5N5

cat inframe/HA_H5N5_NVI2_SEP_inframe.fasta inframe/HA_H5N5_NVI_SEP.fasta >  temp.fasta 

# rechecking formatting is correct 
remove_gaps_check_fun temp.fasta 
# remove eventual duplicates 
## by name 
conda activate seqkit
seqkit rmdup -n temp.fasta > SEP_H5N5_NVI_nodub_HA.fasta # remove was no duplicates by name % 0 duplicates removed 
## check duplicates by sequence but do not remove 
mkdir -p donotuse
seqkit rmdup -si SEP_H5N5_NVI_nodub_HA.fasta  -D donotuse/SEP_H5N5_NVI_dup >  donotuse/test_SEP_H5N5_NVI_nodupseq.fasta # 8 duplicated sequences - inspection  removed 
# clean temporary file 
rm temp.fasta 

```

- [x]  checking for duplicates manually in the file with seq duplicates - no real duplcate ok 

- now concatenating and setting final complete dataset 

```shell 
# copy other input 
# alterantive compcatenation ! This works - because now put a space beween files 
sed -e '$s/$/\n/' -s *.fasta >  H5N5_all_SEP.fasta #85 


# checking removing gaps a last time 
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"
remove_gaps_check_fun H5N5_all_SEP.fasta 
# checking if sequences are ok 
conda activate seqkit 
seqkit sana -i fasta -t dna H5N5_all_SEP.fasta -o dummy > seqkit.sana.log  # ok no problem 

# seems it was 1 duplicate after merging duplicates 
conda activate seqkit 
mv H5N5_all_SEP.fasta temp.fasta 
seqkit rmdup -n temp.fasta > H5N5_all_SEP.fasta

```

---

## MSA - Jalview  
Using jalview - muscle preselection codon - all can run because not too many sequences 
==Adding H5N1 ref for rooting ... this should align fine ==


```jalview 
Jalview Version: 2.11.2.6  
alignment muscle ws preselection 
```

---

## Phylogenetic tree :  iqtree 

```shell 
conda activate iqtree 
iqtree -s H5N5_all_SEP_MSA_jalview.fasta -m MFP+F+I  -B 1000 -T AUTO
IQ-TREE multicore version 2.2.2.9 COVID-edition for Linux 64-bit built Aug  6 2023
Developed by Bui Quang Minh, James Barbetti, Nguyen Lam Tung,
Olga Chernomor, Heiko Schmidt, Dominik Schrempf, Michael Woodhams, Ly Trong Nhan.


MFP model finder that tests the free rate model 
+F empirical base frequencies 
+I allow for proportion of invariable sites
+R rate 
-T threads 
```

----

## Visualisation 
Rscript: `2023-11-15_visualisation_H5N5_SEP.Rmd` and `2023-11-16_visualisation_H5N5_SEP_part2.Rmd`

---

# Final dataset - NA - H5N1 - SEP (continued)

- [x] ==remove the mapping references from dataset 2 gisad == than are not sea eagle good and egypt chikken 
- [x]  ==pasted in SEP_H5N1_ref_NA.fasta ==

## Discarded - redone 
<!-- redone - 
Now concatenating files - Those to use in final  analyses start by SEP 
- [ ] NVI data2 + NVI data1 (order important for check duplicates) + GISAID2 The ones we really want to be included and matched for comparison 
```shell
cat NA_H5N1_NVI2_SEP_inframe.fasta NA_H5N1_NVI_SEP.fasta NA_H5N1_GISAID2_SEP_inframe.fasta > SEP_H5N1_NVI_imptX_NA.fasta 
grep ">" SEP_H5N1_NVI_imptX_NA.fasta | wc -l # 68
```

- [x] now checking for duplicates in the file - for those that are real - the other are not identical but not duplicates 
```
conda activate seqkit 
seqkit rmdup -n SEP_H5N1_NVI_imptX_NA.fasta  > SEP_H5N1_NVI_impt_nodubn_NA.fasta # remove was no duplicates by name (normal as previously)
seqkit rmdup -si SEP_H5N1_NVI_imptX_NA.fasta  -D SEP_H5N1_NVI_dup > SEP_H5N1_NVI_impt_nodubS_NA.fasta # 19 duplicates - inspection  - manually 
```

- [x] now checking for duplicates in the file - for those that are real - the other are not identical but not duplicates - ok its the same that are real duplicates - good to veryfy 
	- 2022_07_1146_1_H5N1|HA|2022_07_1146_1, **A/Northern_gannet/Norway/2022-07-1146-1T/2022|HA|EPI_ISL_18455202**
	- 2022_07_1768_2_H5N1|HA|2022_07_1768_2, **A/Red_fox/Norway/2022-07-1768-2T/2022|HA|EPI_ISL_18455203**

-> Final File is `SEP_H5N1_NVI_impt_ok_NA.fasta`  ( 66 sequences)
- move the other files to donotuse folder 

FINAL FILE 
 
├── NA_H5N1_GISAID_SEP_inframe.fasta
├── SEP_H5N1_NVI_impt_ok_NA.fasta
└── SEP_H5N1_ref_NA.fasta
--> 

-----

## Filtering and concatenating dataset 

NVI total data 

```shell 
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"
SEP_DIR="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep" 

cd ${SEP_DIR}/NA/H5N1

# concatenating datasets that need to be combined : 
sed -e '$s/$/\n/' -s NA_H5N1_NVI2_SEP_inframe.fasta NA_H5N1_NVI_SEP.fasta > NA_H5N1_NVI_concat_SEP_inframe.fasta
# rechecking formatting is correct 
remove_gaps_check_fun  NA_H5N1_NVI_concat_SEP_inframe.fasta

# check for duplicates by name 
remove_duplicates_name_fun NA_H5N1_NVI_concat_SEP_inframe.fasta # 8 duplicates removed 
# check duplicates by sequences - for info and manual check 
remove_duplicates_seq_fun NA_H5N1_NVI_concat_SEP_inframe_nonamedub.fasta # duplicates found - checking manually if tree or false duplicates from the list 
# ok non are real samples duplicates 

# standardization name 
mv NA_H5N1_NVI_concat_SEP_inframe_nonamedub.fasta SEP_H5N1_NVI_nodub_NA.fasta # 68 sequences 
```

## creating reference MSA for H5N1 - NA - N1 
using the ref-representative augmented dataset  - updated references for cropping 
- removal sequences that are not HN1 in mega (that I now of)
	- then I know that there is only H5N5 and H5N1 remaining ... can clearly see the gap for N5 and N5 (H5N5 added are at the top of the file, can clearly see limit - beinning segt)
	- A/chicken/Denmark/S02750-3/2020|NA|EPI ISL 410987 - fist H5N1
	- removing partial  sequences also 
	- check one sequence per different similar block - appear all H5N1 now 
- Exporting 
- removing the gaps that MEGA adds  
```shell 
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"
remove_gaps_check_fun NA_N1_repr_ref_inframe_extended.fas
```

MSA in jalview - muscle protein defaults 

```shell 
conda activate jalview 
jalview 
# muscle alignment protein with presets 
#saving as 
NA_N1_repr_ref_inframe_extended_jalview_initial_alignment.fasta 
```

checking alignment  - so there is a big gap in the middle 


- adding info string in beginning of headers so I can filter those out after 

```
Rscript for_initial_alignment_reformat_ref.R -h 
Rscript for_initial_alignment_reformat_ref.R  --fasta NA_N1_repr_ref_inframe_extended_jalview_initial_alignment.fasta --outname NA_N1_initial_alignment.fasta --outdir .

```

... to be continued 
## Filtering external data by similarity to reduce a bit the dataset 


```shell 
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/NA/H5N1/gisaid1_filtering
# cp gisad1 here - NA_H5N1_GISAID_SEP_inframe.fasta
```

- shortest references in frame are 1343 in length  
```
# filtering short sequences  

Rscript seq_length_filter.R -h
Rscript seq_length_filter.R --fasta NA_H5N1_GISAID_SEP_inframe.fasta --length 1340

# out NA_H5N1_GISAID_SEP_inframe_length_filtered.fasta # 5188 sequences 
```

Filtering by identity using vsearch - against all NVI sequences (only)
```
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"

# I need a resanitizing - still remaining ns or gaps - do both 
remove_gaps_check_fun NA_H5N1_GISAID_SEP_inframe_length_filtered.fasta
remove_gaps_check_fun SEP_H5N1_NVI_nodub_NA.fasta

vsearch_filter_fun SEP_H5N1_NVI_nodub_NA.fasta NA_H5N1_GISAID_SEP_inframe_length_filtered.fasta 0.99  NA_H5N1_GISAID_SEP_inframe_filtered_iddef3_99.fasta # 4676  
```

Extracting those that were match and remove duplicate sequences 
- I use the matched files - check for duplicates (no names duplicates but there are many sequences duplicates)

```
remove_duplicates_name_fun  NA_H5N1_GISAID_SEP_inframe_filtered_iddef3_99.fasta_matched.fasta
# no duplicates 
remove_duplicates_seq_fun  NA_H5N1_GISAID_SEP_inframe_filtered_iddef3_99.fasta_matched.fasta
# we get the list # 2313 duplicated records - but I put that for the tree making as then I get the info 
```

## Concatenating for alignment final 


```shell 
cd/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/NA/H5N1

# checking no gaps and weird sybols for those I did not do 
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"

remove_gaps_check_fun  NA_H5N1_GISAID2_SEP_inframe.fasta
remove_gaps_check_fun  SEP_H5N1_ref_NA.fasta 
```

concatenation - copy all in concatenation all clean 

```shell 
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/NA/H5N1/concatenating_final

sed -e '$s/$/\n/' -s all_clean/*.fasta > SEP_NA_H5N1_clean_total_dataset.fasta # 4749
 sequences 
```

## MSA completing with mafft --add (v7.520)

copy the concatenated total dataset to MSA 
alignment with mafft adding to initial alignment 

```shell 
conda activate mafft 
mafft --maxiterate 5 --add SEP_NA_H5N1_clean_total_dataset.fasta NA_N1_initial_alignment.fasta > SEP_NA_H5N1_MSA0.fasta 
```

## removing the MSA guide from MSA 

- using script R `remove_initial_alignment_from_MSA.R`
seems there is still some duplicate sequences 
this one contains initial_alignment@ 


```shell 
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/NA/H5N1/msab

Rscript remove_initial_alignment_from_MSA.R -h 
Rscript remove_initial_alignment_from_MSA.R --msa SEP_NA_H5N1_MSA0.fasta --outname SEP_NA_H5N1_MSA.fasta --outdir .
# I had forgotten to remove the 0 so errassed previsou file 

```

```
# checking if duplicates in case 


codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"

# per name 
remove_duplicates_name_fun SEP_NA_H5N1_MSA.fasta - 1 duplicate name removed # 4748 sequences 
```

This is still too much sequences ... 
- we need to find a solution 
## phylogeny with IQTREE 

trying anyway - to see  if we can use that to do selection 
```shell 
conda activate iqtree 
iqtree -s SEP_NA_H5N1_MSA_nonamedub.fasta -m MFP+F+I  -B 1000 -T AUTO

```


# NA - H5N5 - SEP (continued)

- [ ] no mapping reference to remove  - but maybe then need to be added at the end if manage to get MSA ok 
## First step DISCARED - Redone 

Now concatenating files - Those to use in final  analyses start by SEP 
- [ ] NVI data2 + NVI data1 (order important for check duplicates) + GISAID2 The ones we really want to be included and matched for comparison 
```shell
cat NA_H5N5_NVI2_SEP_inframe.fasta NA_H5N5_NVI_SEP.fasta NA_H5N5_GISAID2_SEP_inframe.fasta > SEP_H5N5_NVI_imptX_NA.fasta 
grep ">" SEP_H5N5_NVI_imptX_NA.fasta | wc -l # 26
```

- [ ] now checking for duplicates in the file - for those that are real - the other are not identical but not duplicates 
```
conda activate seqkit 
seqkit rmdup -n SEP_H5N5_NVI_imptX_NA.fasta  > SEP_H5N5_NVI_impt_nodubn_NA.fasta # remove was no duplicates by name (normal as previously) ok 

seqkit rmdup -si SEP_H5N5_NVI_imptX_NA.fasta  -D SEP_H5N5_NVI_dup > SEP_H5N5_NVI_impt_nodubS_NA.fasta # 4 duplicates - inspection  - manually 
```

- [x] no real duplicate also - of names but identical sequences 
copy file for homogeneity 

-> Final File is `SEP_H5N5_NVI_impt_ok_NA.fasta`  ( 66 sequences)
- move the other files to donotuse folder 

FINAL FILE  

├── NA_H5N5_GISAID_SEP_inframe.fasta
└── SEP_H5N5_NVI_impt_ok_NA.fasta


----

## Filtering and concatenating dataset 
- few sequences - do not need to be filtered by similarity 

```shell
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"

SEP_DIR="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep" 

cd ${SEP_DIR}/NA/H5N5

# concatenating datasets that need to be combined : 
sed -e '$s/$/\n/' -s NA_H5N5_NVI2_SEP_inframe.fasta NA_H5N5_NVI_SEP.fasta > NA_H5N5_NVI_concat_SEP_inframe.fasta
# rechecking formatting is correct 
remove_gaps_check_fun  NA_H5N5_NVI_concat_SEP_inframe.fasta

# check for duplicates by name 
remove_duplicates_name_fun remove_gaps_check_fun  NA_H5N5_NVI_concat_SEP_inframe.fasta # 0 duplicates removed 

# check duplicates by sequences - for info and manual check 
remove_duplicates_seq_fun NA_H5N5_NVI_concat_SEP_inframe.fasta  # 3 duplicates found - checking manually if tree or false duplicates from the list 
# ok non are real samples duplicates 

# standardization name 
mv NA_H5N5_NVI_concat_SEP_inframe.fasta SEP_H5N5_NVI_nodub_NA.fasta # 25 
```

## Creating reference MSA for H5N5 - NA - N5
### only for trying to merge N1 and N5 
> note this will only be usefull for trying to merge H5N5 and H5N1 - otherwise can do directly 

using the ref-representative augmented dataset  - updated references for cropping 

- removal sequences that are not N5 in mega (that I now of)
	- then I know that there is only H5N5 and H5N1 remaining ... can clearly see the gap for N5 and N5 (H5N5 added are at the top of the file, can clearly see limit - beinning segt)
	- removing partial  sequences also 
	- check one sequence per different similar block - appear all H5N5 now 
- Exporting 
- removing the gaps that MEGA adds  


```
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"
remove_gaps_check_fun NA_repr_ref_inframe_N5.fas
mv NA_repr_ref_inframe_N5.fas NA_repr_ref_inframe_N5.fasta 
```

- [ ] still need to reformat headers if using at later stage 

## Filtering external data by similarity - not necessary - not a lot of external data 

## Concatenating for max final alignment H5N5 

```shell 

cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/NA/H5N5/concatenated_final/all_clean

# checking no gaps and weird sybols for those I did not do 
codedir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code"
source ${codedir}/"final_dataset_check.sh"

remove_gaps_check_fun  NA_H5N5_GISAID2_SEP_inframe.fasta 
remove_gaps_check_fun NA_H5N5_GISAID_SEP_inframe.fasta
remove_gaps_check_fun  SEP_H5N5_NVI_nodub_NA.fasta
```

concatenation ... here try with the H5N1 that they wanted to use as ref for rooting 

```shell 
cd ..

sed -e '$s/$/\n/' -s all_clean/*.fasta > SEP_NA_H5N5_clean_total_dataset.fasta # 85 sequences  

# now checking no duplicates by name and by sequences 
remove_duplicates_name_fun  SEP_NA_H5N5_clean_total_dataset.fasta # 1 duplcate name found > 84 sequences 

# renaming 
mv SEP_NA_H5N5_clean_total_dataset_nonamedub.fasta SEP_NA_H5N5_clean_total.fasta 


# no duplicates by sequence ? 
remove_duplicates_seq_fun  SEP_NA_H5N5_clean_total.fasta 
# we get the list # 18 duplicated records - manual check no real duplicates 
# ok no real duplicates only identical sequences 
```

## MSA using jalview 
muscle with protein preset 

name SEP_NA_H5N5_clean_total_jalview_alignment.fasta 

## Phylogeny with iqtree 



```shell 
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/final_dataset_prep/NA/H5N5/iqtree

conda activate iqtree 
iqtree -s SEP_NA_H5N5_clean_total_jalview_alignment.fasta -m MFP+F+I  -B 1000 -T AUTO > iqtree.log 2>&1

```

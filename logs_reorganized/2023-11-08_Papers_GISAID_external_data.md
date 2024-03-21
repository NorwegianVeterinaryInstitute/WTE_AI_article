
# 2023-11-08_Papers_GISAID_external_data
## grouping references and representative to use to create frame references for AI_pilot 

```shell 
# HA (48 + 66 ) 114 
cat HA_frame_non_alinged_sanitized_references.fasta HA_representative_inframe.fasta > HA_repr_ref_inframe.fasta 
# NA  - 113 total 
cat NA_frame_non_alinged_sanitized_references.fasta NA_representative_inframe_sanitized.fasta > NA_repr_ref_inframe.fasta 
```

---
## Preparing external samples to run - that were downloaded GISAID - for each paper 

Concatenating all fasta files - for simplicity 
Need to ensure that all sequences are valid - character, no gaps ...
```
cd /mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files

# removing ref gaps so could to that above) and validate according to alfabet
cd wrangling 

conda activate seqkit
# testing which one is not good 
seqkit seq -gv -V 0 -t dna 20231018_H5N1_H5N5_2020_gisaid_epiflu_sequence.fasta > 1.fasta #ok 
seqkit seq -gv -V 0 -t dna 20231018_H5N1_H5N5_2021_gisaid_epiflu_sequence.fasta > 2.fasta #ok 
seqkit seq -gv -V 0 -t dna 20231018_H5N1_H5N5_2022_gisaid_epiflu_sequence.fasta > 3.fasta #ok 
seqkit seq -gv -V 0 -t dna  20231018_H5N1_H5N5_2023_up20231018_gisaid_epiflu_sequence.fasta > 4.fasta 
# here is the error at the last one :
A/large-billed_crow/Hokkaido/0103E088/2023|MP|EPI_ISL_17950087
ATATTGAAAGATGAGTCTTCTAACCGAGGTCGAAACGTACG[ERRO] seq: invalid DNAredundant letter: f
was written full at end of sequnece - removed 

seq: invalid DNAredundant letter: e
>A/egret/Korea/22WC603/2023|PB2|EPI_ISL_18242686
aegretkoreawcpbat - removed aegretkoreawcpb

So now it seems clean 

# concatenating
cat 1.fasta 2.fasta 3.fasta 4.fasta > concat.fasta

# eventual fix of headers problems
sed -i 's#>>#>##' concat.fasta 

# eventual sanitizing again  
seqkit sana -i fasta -t dna concat.fasta -o concat2.fasta
# seemed ok 
# eventual removal of duplicates by name 
seqkit rmdup -n -D duplicate_seq concat2.fasta > concat3.fasta 
# !! 107 duplicated records removed - wondering why !! 

# MB there are duplicate sequences - but wont use that I want that now - just keep the list
seqkit rmdup -s -P -D duplicate_seq_byseq concat3.fasta  
# !! 21453 duplicated records removed

# Seems there are non unicode characters
grep -axv '.*' concat3.fasta 
# ok its in the headers ! 
# keeping track of those headers 
grep -axv '.*' concat3.fasta > non_unicode_headers

# try remove those characters https://www.baeldung.com/linux/remove-non-utf-8-characters
iconv -f utf-8 -t utf-8 -c concat3.fasta -o concat4.fasta 
grep -axv '.*' concat4.fasta # ok that semmed to work 

# so I need to check if the whole line or just character was removed ! 
# this is good it did remove only the character 

# keep a copy of clean file 
cp concat4.fasta ../20231018_from2020_top20231018_H5N1_H5N5_gisaid_epiflu_sequence.fasta 
```

```
PYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/split_fasta.py"

conda activate biopython 
### creating files per segment 
python $PYSCRIPT 
python $PYSCRIPT --fasta concat4.fasta --outdir segments 
```

- Now cutting those into segments  - good, this time it works, format should be ok 
- removing temporary files concat.fasta, concat2.fasta and concat3.fasta 

```
### concatenating each segment 
segt=( HA PB2 PB1 NS PA NP NA MP )

for each in ${segt[@]}
do 
cat segments/${each}*.fasta > ${each}_H5N1_H5N5_GISAID.fasta
done 
```
- removing temporary segments folder 

> **now preparing in Rscript the filtering for each paper** 

Creating segments datasets for each paper (all segments in case people change their mind, only took some min ...)
Rscript:: [[Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/2023-10-25_prepare_datasets_GISAID_data.Rmd|2023-10-25_prepare_datasets_GISAID_data]]

Note: 
**SeaEagle paper (SEP)**
- samples from 2020-2022 
- HA and NA
**Arctic paper (AP)**
- samples from 2021 - oktober 2023
- HA and NA (at first) 


## HA and NA segments - external data from GISAID - In frame - for each paper 

### SEP  (HA-NA inframe - OK)

--- 
#### HA
- using vsearch to crop detect the frame - use the ref_repr_genotypes dataset -> then check in MEGA and in the tsv file from vsearch that shows the matches 

##### H5N1
```shell
cd 12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/SEP/HA/H5N1
conda activate vsearch

vsearch  --db ../HA_repr_ref_inframe.fasta --usearch_global ../HA_H5N1_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N1_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N1_GISAID_SEP_alignment.aln \
--fastapairs HA_H5N1_GISAID_SEP_fastapairs.fasta \
--matched HA_H5N1_GISAID_SEP_matched.fasta \
--notmatched HA_H5N1_GISAID_SEP_notmatched.fasta \
--log HA_H5N1_GISAID_SEP_vsearch.log  --notrunclabels 

```
> result: Matching unique query sequences: 5277 of 5440 (97.00%)
- [x] Ok we have some that did not work - why ? - what are those ? - just different 
- [x] ok - so we go iteratively and add new references and test again 
- [x] Edit wit mega - search the protein - crop in frame 
- [x] mega is alwaus fas -> so do not rename do that when sanitizing : with seqkit 
- [x] then rerun vsearch 
- [x] Do a loop until all are cropped automatically ! ==We want most complete reference for eventual reanalyze - additional analyses== 

```shell 
cd ..
seqkit seq -gl -o HA_repr_ref_inframe_extended.fasta HA_repr_ref_inframe_extended.fas 
cd H5N1

vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N1_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N1_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N1_GISAID_SEP_alignment.aln \
--fastapairs HA_H5N1_GISAID_SEP_fastapairs.fasta \
--matched HA_H5N1_GISAID_SEP_matched.fasta \
--notmatched HA_H5N1_GISAID_SEP_notmatched.fasta \
--log HA_H5N1_GISAID_SEP_vsearch.log  --notrunclabels 
```

added :
- round 1: >A/duck/Laos/NL-2072063/2020|HA|EPI_ISL_1291196. now: Matching unique query sequences: 5318 of 5440 (97.76%) 
- round 2:  >A/chicken/EastJava/Jombang/1563/2020|HA|EPI_ISL_17712521. now: Matching unique query sequences: 5347 of 5440 (98.29%)
- round 3:  >A/chicken/NorthSumatra/Medan/1509/2020|HA|EPI_ISL_17712471. now: Matching unique query sequences: 5348 of 5440 (98.31%)
- round 4: >A/chicken/Bangladesh/46222/2020|HA|EPI_ISL_14776045. now: Matching unique query sequences: 5439 of 5440 (99.98%)
- round 5: > >A/duck/Bangladesh/BAIV-404_HA/2021|HA|EPI_ISL_17239056. Matching unique query sequences: 5440 of 5440 (100.00%)

**now imposing id 0.985**

```shell 
cd ..
seqkit seq -gl -o HA_repr_ref_inframe_extended.fasta HA_repr_ref_inframe_extended.fas 
cd H5N1

vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N1_GISAID_SEP_full_segment.fasta \
--id 0.985 --iddef 2 \
--userout HA_H5N1_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N1_GISAID_SEP_alignment.aln \
--fastapairs HA_H5N1_GISAID_SEP_fastapairs.fasta \
--matched HA_H5N1_GISAID_SEP_matched.fasta \
--notmatched HA_H5N1_GISAID_SEP_notmatched.fasta \
--log HA_H5N1_GISAID_SEP_vsearch.log  --notrunclabels 
```

Matching unique query sequences: 5290 of 5440 (97.24%)
added:
- round1 : >A/chicken/Riau/Pekanbaru/1529/2020|HA|EPI_ISL_17712475. now: Matching unique query sequences: 5293 of 5440 (97.30%)
- round2: >A/chicken/Lampung/Tanggamus/1497/2020|HA|EPI_ISL_17710038. now: Matching unique query sequences: 5294 of 5440 (97.32%)

Hum I think actually they are similar enough for grouping to be good do a recheck 
- opening in jalview - seems ok like refs. 
- checking the userout 
	- we have one query > length target -> this one need to be fixed 
	- we need better sequence thant seq eagle 
		- we need to add manually in frame some of the queries to the references. Queries that had better match with sea-eagle, important as it can help pattern !!! 

for those that mach:
- 20|HA|H5N5|I A/sea eagle/Norway/2022-07-100 22VIR2882-2/2022|H5N5|EPI ISL 12028892,  choose sequences that are long: and rerun to test.
	- [x] A/common_buzzard/Japan/2601B013/2022|HA|EPI_ISL_16831015
	- [x] A/African_penguin/South_Africa/21100423A/2021|HA|EPI_ISL_15839837
	- [x] A/peregrine_falcon/Kanagawa/1409C001T1/2022|HA|EPI_ISL_15923322
- 20|HA|H5N1|AG A/duck/Bulgaria/827-2 22VIR778-8/2021|H5N1|EPI ISL 11009382, add:
	- [x] A/mute_swan/England/334590/2022|HA|EPI_ISL_16384190
- 12|HA|H5N8|A/guinea fowl/Germany-NW/AI01184/2020|H5N8|EPI ISL 661312
	- [x] A/mallard/Netherlands/21041322-001/2021|HA|EPI_ISL_8799315
round 1: 
Added partial in front of sequences so its easier to check quality 
round 2 : 
now Sorting results (target ascending, query-ascending) 
- choose to add those that match short target and that have longuer query, for the different sizes of target match 
- add also those that match to sea eagle - that are long
round 3: adding a few more that match to partial or a bit shorter sequences to be sure 
- [x] A/Bar-headed_Goose/Tibet/XZ1131/2021|HA|EPI_ISL_8215689 
- [x] A/avian/Nigeria/023_22VIR3286-44/2022|HA|EPI_ISL_17414583
- [x] A/chicken/Nigeria/064_22VIR3286-55/2022|HA|EPI_ISL_17414626
- [x] A/Gallus_gallus/Belgium/11943_0003/2022|HA|EPI_ISL_15699929
- [x] A/goose/Czech_Republic/20689-28T/2021|HA|EPI_ISL_6512576

==NB: was no need to reorient== 

> NOTE 
- [ ] need to see if --id 0.96  is sufficient ... I do not want to do many rounds again 
Last round 

```shell 
cd ..
seqkit seq -gl -o HA_repr_ref_inframe_extended.fasta HA_repr_ref_inframe_extended.fas 
cd H5N1

vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N1_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N1_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N1_GISAID_SEP_alignment.aln \
--fastapairs HA_H5N1_GISAID_SEP_fastapairs.fasta \
--matched HA_H5N1_GISAID_SEP_matched.fasta \
--notmatched HA_H5N1_GISAID_SEP_notmatched.fasta \
--log HA_H5N1_GISAID_SEP_vsearch.log  --notrunclabels 
```

==This is ok all the files are filtered out according to a long query now ==
Some will be too short to be analysed but we sort later on 


##### H5N5
round1 

```
cd 12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/SEP/HA/H5N5
conda activate vsearch

vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N5_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N5_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N5_GISAID_SEP_alignment.aln \
--fastapairs HA_H5N5_GISAID_SEP_fastapairs.fasta \
--matched HA_H5N5_GISAID_SEP_matched.fasta \
--notmatched HA_H5N5_GISAID_SEP_notmatched.fasta \
--log HA_H5N5_GISAID_SEP_vsearch.log  --notrunclabels 

# Matching unique query sequences: 56 of 56 (100.00%)
```

checked on GISAID - was no more isolates that that  (some 3 more might have been released now as there are 59 isolates)
seems no need to do second round - checking in case the tsv - need to add some that were too short to the references 
%% adding large to be sure %% 
- [x] A/sea_eagle/Norway/2022-07-198_22VIR3866-2/2022|HA|EPI_ISL_12754536
- [x] A/waterfowl/Russia/1526-4/2021|HA|EPI_ISL_16209278
- [x] A/Chicken/Sweden/SVA210201SZ0080/FB000693-IP4/2021|HA|EPI_ISL_12980521
- [x] A/black-necked_grebe/Kalmykia/78-1V/2021|HA|EPI_ISL_8769032
- [x] A/brent_goose/England/095684/2020|HA|EPI_ISL_1123358
- [x] A/Mute_Swan/Sweden/SVA210330SZ0417/FB001305/D-2021|HA|EPI_ISL_3294584 (just to be sure that not croping to short otherwise)


- round 2 now 

```
cd ..
seqkit seq -gl -o HA_repr_ref_inframe_extended.fasta HA_repr_ref_inframe_extended.fas 

cd H5N5
vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N5_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N5_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N5_GISAID_SEP_alignment.aln \
--fastapairs HA_H5N5_GISAID_SEP_fastapairs.fasta \
--matched HA_H5N5_GISAID_SEP_matched.fasta \
--notmatched HA_H5N5_GISAID_SEP_notmatched.fasta \
--log HA_H5N5_GISAID_SEP_vsearch.log  --notrunclabels 

```
- [ ] A/sea_eagle/Norway/2022-07-100_22VIR2882-2/2022|HA|EPI_ISL_12028892 (this one wont align in full lenght otherwise because its shorter, but its better than the previous ) 


- round 3 (as round2) - its ok now, I cannot improve more - because longer fragments are outside frame 

-----
#### NA 
##### H5N1
- using vsearch to crop detect the frame - then check in MEGA and in the tsv file that shows the matches 
path 
`12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/SEP/NA`

round 1
```sheel 
cd 12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/SEP/NA 

# ok - seems some unclean data escaped - check 
seqkit sana -i fasta -t dna NA_repr_ref_inframe.fasta  # seems ok 
seqkit sana -i fasta -t dna NA_H5N1_GISAID_SEP_full_segment.fasta # seems ok 
seqkit sana -i fasta -t dna NA_H5N5_GISAID_SEP_full_segment.fasta # seems ok 

# So must be a gap somewhere - yes that was that 
mv NA_repr_ref_inframe.fasta NA_repr_ref_inframe_tmp.fasta
seqkit seq -g -o NA_repr_ref_inframe.fasta  NA_repr_ref_inframe_tmp.fasta  
```

ok - now we can launch 

```shell 
cd H5N1 
vsearch  --db ../NA_repr_ref_inframe.fasta --usearch_global ../NA_H5N1_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N1_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N1_GISAID_SEP_alignment.aln \
--fastapairs NA_H5N1_GISAID_SEP_fastapairs.fasta \
--matched NA_H5N1_GISAID_SEP_matched.fasta \
--notmatched NA_H5N1_GISAID_SEP_notmatched.fasta \
--log NA_H5N1_GISAID_SEP_vsearch.log  --notrunclabels 

#Matching unique query sequences: 4964 of 5206 (95.35%) 
```

checking tsv - checking which sequences need to be added manually 
- [x] checked - those that do not work are just too short 
- [x] Adding  some of those that were not mached 
- [x] marked those that were partial and bad quality 

round 2 
```shell
cd ..
seqkit seq -gl -o NA_repr_ref_inframe_extended.fasta NA_repr_ref_inframe_extended.fas 

cd H5N1 
vsearch  --db ../NA_repr_ref_inframe_extended.fasta --usearch_global ../NA_H5N1_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N1_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N1_GISAID_SEP_alignment.aln \
--fastapairs NA_H5N1_GISAID_SEP_fastapairs.fasta \
--matched NA_H5N1_GISAID_SEP_matched.fasta \
--notmatched NA_H5N1_GISAID_SEP_notmatched.fasta \
--log NA_H5N1_GISAID_SEP_vsearch.log  --notrunclabels 

#Matching unique query sequences: 5206 of 5206 (100.00%)
```

ok, some short I need to filter - but cannot do anything else 

##### H5N5


round 1
```shell 
cd H5N5 
vsearch  --db ../NA_repr_ref_inframe_extended.fasta --usearch_global ../NA_H5N5_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N5_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N5_GISAID_SEP_alignment.aln \
--fastapairs NA_H5N5_GISAID_SEP_fastapairs.fasta \
--matched NA_H5N5_GISAID_SEP_matched.fasta \
--notmatched NA_H5N5_GISAID_SEP_notmatched.fasta \
--log NA_H5N5_GISAID_SEP_vsearch.log  --notrunclabels 

#Matching unique query sequences: 53 of 54 (98.15%)
```

Adding sequences that were too different - non matched  (1)
adding references where query longer than target and could be same 
A/sea_eagle/Norway/2022-07-196_22VIR3866-1/2022|NA|EPI_ISL_12754535
A/mute_swan/Czech_Republic/4099/2021|NA|EPI_ISL_10364607
A/gull/Dagestan/397-2/2021|NA|EPI_ISL_16209275
A/mute_swan/Slovakia/Pah6_21VIR1086-2/2021|NA|EPI_ISL_1665262
A/whooper_swan/Romania/10311_21VIR849-2/2021|NA|EPI_ISL_1665269
A/eagle/Hungary/8569/2021_(H5N5)|NA|EPI_ISL_3135926
A/mute_swan/Romania/11981-1_21VIR3163-5/2021|NA|EPI_ISL_3102081
A/brent_goose/England/095684/2020|NA|EPI_ISL_1123358

round 2

```shell 
cd ..
seqkit seq -gl -o NA_repr_ref_inframe_extended.fasta NA_repr_ref_inframe_extended.fas 

cd H5N5 
vsearch  --db ../NA_repr_ref_inframe_extended.fasta --usearch_global ../NA_H5N5_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N5_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N5_GISAID_SEP_alignment.aln \
--fastapairs NA_H5N5_GISAID_SEP_fastapairs.fasta \
--matched NA_H5N5_GISAID_SEP_matched.fasta \
--notmatched NA_H5N5_GISAID_SEP_notmatched.fasta \
--log NA_H5N5_GISAID_SEP_vsearch.log  --notrunclabels 

# Matching unique query sequences: 54 of 54 (100.00%)
```
- recheck if no more alignment to partial sequence 
- those that group with partial seq eagle 
A/swan/Rostov/2299-2/2020|NA|EPI_ISL_16209276
A/European_herring_gull/Bulgaria/222_21VIR4270-1/2021|NA|EPI_ISL_3102054
A/grey_heron/Bulgaria/223_21VIR4270-2/2021|NA|EPI_ISL_3102055
A/pelican/Dagestan/397-1/2021|NA|EPI_ISL_16209274

round 3 (same command round2)
recheck - I cannot improve now, some sequences still short 


- [ ] ==Those I think I will need to filter so they are closely related to our dataset == because there is a lot difference alignment in the Ns

----
### AP 
> reusing the references from SEP ... adding if new are not detected automatically 
> using vsearch and seqkit as for SEP 
#### HA

##### H5N1

round 1
```shell 
cd H5N1 
vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N1_GISAID_AP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N1_GISAID_AP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N1_GISAID_AP_alignment.aln \
--fastapairs HA_H5N1_GISAID_AP_fastapairs.fasta \
--matched HA_H5N1_GISAID_AP_matched.fasta \
--notmatched HA_H5N1_GISAID_AP_notmatched.fasta \
--log HA_H5N1_GISAID_AP_vsearch.log  --notrunclabels 
# Matching unique query sequences: 6636 of 6637 (99.98%)
# vsearch v2.23.0_linux_x86_64 
```

- inspecting tsv and  non matched sequences 
	- ==there is quiet a lot of query that are short== 
	- hum ... I think my selection was not the best, see in round 2 - and had forgotten the unaligned ... shit 

round 2

```shell 
cd ..
seqkit seq -gl -o HA_repr_ref_inframe_extended.fasta HA_repr_ref_inframe_extended.fas 

vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N1_GISAID_AP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N1_GISAID_AP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N1_GISAID_AP_alignment.aln \
--fastapairs HA_H5N1_GISAID_AP_fastapairs.fasta \
--matched HA_H5N1_GISAID_AP_matched.fasta \
--notmatched HA_H5N1_GISAID_AP_notmatched.fasta \
--log HA_H5N1_GISAID_AP_vsearch.log  --notrunclabels 

```

hum ... not sure I can do more - adding the unmatched but seems partial anyway - yes its a partial one 

round 3 - same command 
ok - do not know what I had done before but seems better now, and seems I can get some more references ... 
reorganised the partial --- 


round4 
Hum I see still in the queries that some references are counted as long because they contain n at the begining and end of sequence 
so will be last round of adding, because if its not better its because artificially long sequences due to ns. 

- several n inserted for those sequences - quality unsure 
-  ==hum I think I will need a final round for all after that to be sure that did not miss anything for each paper , because then all the partial have been spotted and best ref are added ==
- added to do 
==Hum, I think I need to remove the partial sequences, otherwise that mask the real ones, because we have so many and then does not crop in frame ==
done 

round 5
==A/chicken/Egypt/NRC-001/2023|HA|EPI_ISL_18363569 not matched . but this is a short sequence length 535 - so I do not add this one ==

##### H5N5

```shell 
cd H5N5 
vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N5_GISAID_AP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N5_GISAID_AP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N5_GISAID_AP_alignment.aln \
--fastapairs HA_H5N5_GISAID_AP_fastapairs.fasta \
--matched HA_H5N5_GISAID_AP_matched.fasta \
--notmatched HA_H5N5_GISAID_AP_notmatched.fasta \
--log HA_H5N5_GISAID_AP_vsearch.log  --notrunclabels 

# vsearch v2.23.0_linux_x86_64 
```

This one is ok nothing to modify 
#### NA 


##### H5N1

round 1

```sheel
cd H5N1 
vsearch  --db ../NA_repr_ref_inframe_extended.fasta --usearch_global ../NA_H5N1_GISAID_AP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N1_GISAID_AP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N1_GISAID_AP_alignment.aln \
--fastapairs NA_H5N1_GISAID_AP_fastapairs.fasta \
--matched NA_H5N1_GISAID_AP_matched.fasta \
--notmatched NA_H5N1_GISAID_AP_notmatched.fasta \
--log NA_H5N1_GISAID_AP_vsearch.log  --notrunclabels 

# vsearch v2.23.0_linux_x86_64 
```


ok - bad partial match to each other, otherwise only too short - let as is 
one - non matched - the sequence has been padded with n (rrrr) --- A/wildbird-Sula-nebouxii/Ecuador/7611/2023|NA|EPI ISL 18137671 
added this reference .
Let it as is and will recheck in the final round 

```
seqkit seq -gl -o NA_repr_ref_inframe_extended.fasta NA_repr_ref_inframe_extended.fas 
```

##### H5N5

```
cd H5N5 
vsearch  --db ../NA_repr_ref_inframe_extended.fasta --usearch_global ../NA_H5N5_GISAID_AP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N5_GISAID_AP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N5_GISAID_AP_alignment.aln \
--fastapairs NA_H5N5_GISAID_AP_fastapairs.fasta \
--matched NA_H5N5_GISAID_AP_matched.fasta \
--notmatched NA_H5N5_GISAID_AP_notmatched.fasta \
--log NA_H5N5_GISAID_AP_vsearch.log  --notrunclabels 

# vsearch v2.23.0_linux_x86_64 
```
- all are matched 
- checking Tsv - cannot do better to those that match partial segments ... 
- 
--- 
# Final round as recheck for all papers - for GISAID data 
> updated the references for HA and NA with the latest for each paper 


## SEP 

==So final path for files that are ok `12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/SEP/HA`
for concatenated dataset, and `H1N1` or `H5N5` for separate dataset ==

- HA  - max target segment length, will be used after for filtering  = 
### HA 

- H5N1

```sheel 
vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N1_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N1_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N1_GISAID_SEP_alignment.aln \
--fastapairs HA_H5N1_GISAID_SEP_fastapairs.fasta \
--matched HA_H5N1_GISAID_SEP_matched.fasta \
--notmatched HA_H5N1_GISAID_SEP_notmatched.fasta \
--log HA_H5N1_GISAID_SEP_vsearch.log  --notrunclabels 

```

- [x] Testing tsv file again 
	- some very short - will have to be filtered  - some short but cannot do anything about 
- [x] non matched -> 0

Final seq to export  for H5N1 

```shell 
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment HA_H5N1_GISAID_SEP_fastapairs.fasta --output HA_H5N1_GISAID_SEP_inframe.fasta 

grep ">" HA_H5N1_GISAID_SEP_inframe.fasta  | wc -l
# 5440 
```


- H5N5
> 
```sheel 
vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N5_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N5_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N5_GISAID_SEP_alignment.aln \
--fastapairs HA_H5N5_GISAID_SEP_fastapairs.fasta \
--matched HA_H5N5_GISAID_SEP_matched.fasta \
--notmatched HA_H5N5_GISAID_SEP_notmatched.fasta \
--log HA_H5N5_GISAID_SEP_vsearch.log  --notrunclabels 
```

- [x] testing tsv file  cannot do better 
- [x] non matched -> 0

```
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment HA_H5N5_GISAID_SEP_fastapairs.fasta --output HA_H5N5_GISAID_SEP_inframe.fasta 

grep ">" HA_H5N5_GISAID_SEP_inframe.fasta   | wc -l

```

- Concatenating  H5N1 and H5N1 

```
cat H5N1/HA_H5N1_GISAID_SEP_inframe.fasta H5N5/HA_H5N5_GISAID_SEP_inframe.fasta > HA_H5N1_H5N5_GISAID_SEP_inframe.fasta

# eventual removal of duplicates by name (check) - does not detect so seems nothing 
seqkit rmdup -n -D HA_H5N1_H5N5_GISAID_SEP_inframe.fasta 
```

- [x] ready to be employed as dataset  HA_H5N1_H5N5_GISAID_SEP_inframe.fasta  
- [x] cleaning relics temporary files - save (but not the rounds files yet)



### NA 
- H5N1


```shell 
vsearch  --db ../NA_repr_ref_inframe_extended.fasta --usearch_global ../NA_H5N1_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N1_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N1_GISAID_SEP_alignment.aln \
--fastapairs NA_H5N1_GISAID_SEP_fastapairs.fasta \
--matched NA_H5N1_GISAID_SEP_matched.fasta \
--notmatched NA_H5N1_GISAID_SEP_notmatched.fasta \
--log NA_H5N1_GISAID_SEP_vsearch.log  --notrunclabels 

```

- [x] Testing tsv file again 
- [x] non matched -0

```sheel 
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment NA_H5N1_GISAID_SEP_fastapairs.fasta --output NA_H5N1_GISAID_SEP_inframe.fasta 

grep ">" NA_H5N1_GISAID_SEP_inframe.fasta | wc -l
# 5206
```

- H5N5


```sheel 
vsearch  --db ../NA_repr_ref_inframe_extended.fasta --usearch_global ../NA_H5N5_GISAID_SEP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N5_GISAID_SEP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N5_GISAID_SEP_alignment.aln \
--fastapairs NA_H5N5_GISAID_SEP_fastapairs.fasta \
--matched NA_H5N5_GISAID_SEP_matched.fasta \
--notmatched NA_H5N5_GISAID_SEP_notmatched.fasta \
--log NA_H5N5_GISAID_SEP_vsearch.log  --notrunclabels 

```
- [x] Testing tsv file again  nothing that can be improved 
- [x] non matched  -0 

```sheel 
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment NA_H5N5_GISAID_SEP_fastapairs.fasta --output NA_H5N5_GISAID_SEP_inframe.fasta 

grep ">" NA_H5N5_GISAID_SEP_inframe.fasta | wc -l
# 54
```


- Concatenating - do not think will be able to use not separated, but can try
- [ ] concatenating 
- [ ] remove duplicate sequences (seqkit) - incase 
```
cat H5N1/NA_H5N1_GISAID_SEP_inframe.fasta H5N5/NA_H5N5_GISAID_SEP_inframe.fasta > NA_H5N1_H5N5_GISAID_SEP_inframe.fasta

# eventual removal of duplicates by name (check - should not be) - does not detect anything all good
seqkit rmdup -n -D NA_H5N1_H5N5_GISAID_SEP_inframe.fasta 
```

## AP

### HA 
- H5N1



```shell 

vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N1_GISAID_AP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N1_GISAID_AP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N1_GISAID_AP_alignment.aln \
--fastapairs HA_H5N1_GISAID_AP_fastapairs.fasta \
--matched HA_H5N1_GISAID_AP_matched.fasta \
--notmatched HA_H5N1_GISAID_AP_notmatched.fasta \
--log HA_H5N1_GISAID_AP_vsearch.log  --notrunclabels 

```


- [x] Testing tsv file again 
- [ ] non matched  >A/chicken/Egypt/NRC-001/2023|HA|EPI_ISL_18363569 - its a short one - I would have to remove it - so I do not use it 
==so if short - not added to representative == 

```shell 
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment HA_H5N1_GISAID_AP_fastapairs.fasta --output HA_H5N1_GISAID_AP_inframe.fasta 

grep ">" HA_H5N1_GISAID_AP_inframe.fasta | wc -l
#6636 
```

- H5N5

 
```shell 
vsearch  --db ../HA_repr_ref_inframe_extended.fasta --usearch_global ../HA_H5N5_GISAID_AP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout HA_H5N5_GISAID_AP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout HA_H5N5_GISAID_AP_alignment.aln \
--fastapairs HA_H5N5_GISAID_AP_fastapairs.fasta \
--matched HA_H5N5_GISAID_AP_matched.fasta \
--notmatched HA_H5N5_GISAID_AP_notmatched.fasta \
--log HA_H5N5_GISAID_AP_vsearch.log  --notrunclabels 

```


- [x] Testing tsv file again 
- [x] non matched -0

```shell 
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment HA_H5N5_GISAID_AP_fastapairs.fasta --output HA_H5N5_GISAID_AP_inframe.fasta 

grep ">" HA_H5N5_GISAID_AP_inframe.fasta | wc -l
#42
```

- Concatenating 

```
cat H5N1/HA_H5N1_GISAID_AP_inframe.fasta H5N5/HA_H5N5_GISAID_AP_inframe.fasta > HA_H5N1_H5N5_GISAID_AP_inframe.fasta

# eventual removal of duplicates by name (check) - does not detect so seems nothing 
seqkit rmdup -n -D HA_H5N1_H5N5_GISAID_AP_inframe.fasta 
```

- [x] ready to be employed as dataset  HA_H5N1_H5N5_GISAID_SEP_inframe.fasta  
- [x] cleaning relics temporary files - save (but not the rounds files yet)

### NA 
- H5N1



```shell 
vsearch  --db ../NA_repr_ref_inframe_extended.fasta --usearch_global ../NA_H5N1_GISAID_AP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N1_GISAID_AP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N1_GISAID_AP_alignment.aln \
--fastapairs NA_H5N1_GISAID_AP_fastapairs.fasta \
--matched NA_H5N1_GISAID_AP_matched.fasta \
--notmatched NA_H5N1_GISAID_AP_notmatched.fasta \
--log NA_H5N1_GISAID_AP_vsearch.log  --notrunclabels 

```

- [x] Testing tsv file again 
- [x] non matched  0
```shell 
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment NA_H5N1_GISAID_AP_fastapairs.fasta --output NA_H5N1_GISAID_AP_inframe.fasta 

grep ">" NA_H5N1_GISAID_AP_inframe.fasta | wc -l
#6411
```

- H5N5



```shell 
vsearch  --db ../NA_repr_ref_inframe_extended.fasta --usearch_global ../NA_H5N5_GISAID_AP_full_segment.fasta \
--id 0.96 --iddef 2 \
--userout NA_H5N5_GISAID_AP_userout.tsv \
--userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
--maxhits 1 --maxaccepts 100 --maxrejects 100 \
--alnout NA_H5N5_GISAID_AP_alignment.aln \
--fastapairs NA_H5N5_GISAID_AP_fastapairs.fasta \
--matched NA_H5N5_GISAID_AP_matched.fasta \
--notmatched NA_H5N5_GISAID_AP_notmatched.fasta \
--log NA_H5N5_GISAID_AP_vsearch.log  --notrunclabels 

```

- [x] Testing tsv file again 
- [x] non matched -0


```shell 
MYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
Rscript $MYSCRIPT --alignment NA_H5N5_GISAID_AP_fastapairs.fasta --output NA_H5N5_GISAID_AP_inframe.fasta 

grep ">" NA_H5N5_GISAID_AP_inframe.fasta | wc -l
# 40
```

- Concatenating 

```
cat H5N1/NA_H5N1_GISAID_AP_inframe.fasta H5N5/NA_H5N5_GISAID_AP_inframe.fasta > HA_H5N1_H5N5_GISAID_AP_inframe.fasta

# eventual removal of duplicates by name (check) - does not detect so seems nothing 
seqkit rmdup -n -D NA_H5N1_H5N5_GISAID_AP_inframe.fasta 
```

- [x] ready to be employed as dataset  NA_H5N1_H5N5_GISAID_AP_inframe.fasta  
- [x] cleaning relics temporary files - save (but not the rounds files yet)

## summary data we can use for comparison from GISAID 

| Article | segment | subtype | max inframe target length | nb sequences before size filtering |
| ------- | ------- | ------- | ------------------------- | ---------------------------------- |
| SEP     | HA      | H5N1    | 1703                      | 5440                               |
| SEP     | HA      | H5N5    | 1703                      | 56                                 |
| SEP     | NA      | H5N1    | 1343-  1409               | 5206                               |
| SEP     | NA      | H5N5    | 1418                      | 54                                 |
| AP      | HA      | H5N1    | 1694 - 1703               | 6636                               |
| AP      | HA      | H5N5    | 1703                      | 42                                 |
| AP      | NA      | H5N1    |     1343-  1409                    |      6411                              |
| AP      | NA      | H5N5    |     1418                      |   40                                 |
|         |         |         |                           |                                    |

... Saving data - with final references 
- [x] removing temporary folders - rounds 
ok ... had moved files instead of copy - so restaured the backups 
is also on the drive and in final dataset prepr for each article 

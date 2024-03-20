#!/bin/bash
## All original files have to be in an original folder 
## to modify interactively 
##MY_MAINDIR="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/sea_eagle_consensus/data_2_ok/H5N1"
##MY_STRAIN="H5N1"
##MY_ARTICLE="SEP"
##MY_DATASET="NVI2"
##MY_INFRAME_SEGTS_ARRAY=( "HA" "NA" )


## keep vars - paths - unless changing them 
MY_RSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/reformat_NVI_headers.R"
MY_PYSCRIPT="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/split_fasta.py"
MY_RSCRIPT2="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/code/filtering_frame_cropping_vsearch.R"
## This is for running vsearch

uprefdir="/mnt/2T/Insync/ONEDRIVE/REINSTALLED/projects_vault/Projects/2023/1_AvianInfluenza/12302_Avian_influenza_2023/data/GISAID_data/files/filtered_per_article/inframe_cropping/updated_references"

## renaming files 
rename_files_fun(){
    cd $MY_MAINDIR/original 
    rename 'Consensus_' '' *.fasta
    cd $MY_MAINDIR
    }

## sanitizing
remove_gaps_fun(){
    
    cd $MY_MAINDIR
    mkdir -p sanitized
    conda activate seqkit
    
    for file in $(ls original/*.fasta)
    do
    id=$(echo $file | sed -e "s#original/##")
    seqkit seq -g -G "- N n " -o sanitized/${id} ${file}
    done
    conda deactivate
    }

## reformating NVI headers
reformating_NVI_headers_fun(){
    
    cd $MY_MAINDIR
    mkdir -p reformated
    
    for file in $(ls sanitized/*.fasta)
    do
    Rscript $MY_RSCRIPT --sample $file --strain $MY_STRAIN --outdir reformated
    done
    
    cd $MY_CWD
    }

## concatenating all reformated 
concat_reformated_fun(){
    cd $MY_MAINDIR
    
    sed -e '$s/$/\n/' -s reformated/*.fasta > ${MY_ARTICLE}_${MY_STRAIN}_${MY_DATASET}.fasta 
    # Concatenation bellow can lead to problem for lines
    # cat reformated/*.fasta > ${MY_ARTICLE}_${MY_STRAIN}_${MY_DATASET}.fasta
    }


## creating files per segment     
create_segments_files_fun(){
    
    cd $MY_MAINDIR
    mkdir -p segments_files
    
    conda activate biopython
    python ${MY_PYSCRIPT} --fasta ${MY_ARTICLE}_${MY_STRAIN}_${MY_DATASET}.fasta --outdir segments_files
    conda deactivate
    }

## concatenating segments file 
concatenate_segments_files_fun(){
    
    cd $MY_MAINDIR
    segt=( HA PB2 PB1 NS PA NP NA MP )
    mkdir -p segments
    
    for each in ${segt[@]}
    do 
    cat segments_files/${each}*.fasta > segments/${each}_${MY_STRAIN}_${MY_DATASET}_${MY_ARTICLE}.fasta
    done
    }

## creating segments in frame
vsearch_inframe_fun(){
    cd $MY_MAINDIR/segments
    conda activate vsearch
    
    for segt in ${MY_INFRAME_SEGTS_ARRAY[@]}
    do
    ## get the right reference path
    SEG_REF="$uprefdir/${segt}_repr_ref_inframe_extended.fasta"
    ## create result directory
    mkdir -p ${segt}_inframe && cd ${segt}_inframe
    
    ##to make it clearer
    prefix="${segt}_${MY_STRAIN}_${MY_DATASET}_${MY_ARTICLE}"
    
    ## creating segments in frame
    vsearch  --db ${SEG_REF} --usearch_global ../${prefix}.fasta \
    --id 0.96 --iddef 2 \
    --userout ${prefix}_userout.tsv \
    --userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
    --maxhits 1 --maxaccepts 100 --maxrejects 100 \
    --alnout ${prefix}_alignment.aln \
    --fastapairs ${prefix}_fastapairs.fasta \
    --matched ${prefix}_matched.fasta \
    --notmatched ${prefix}_notmatched.fasta \
    --log ${prefix}_vsearch.log  --notrunclabels
    
    ## adding the header line to go faster
    sed -i '1 i query\ttarget\talnlen\tmism\topens\texts\tgaps\tqlo\tqhi\ttlo\tthi\tqs\tts\tid0\tid1\tid2\tid3\tid4\t' ${prefix}_userout.tsv
    ## go back into correct directory
    cd $MY_MAINDIR/segments
    done
    
    conda deactivate 
    cd $MY_MAINDIR
    }

## setting all final datasets in frame 
final_inframe_fun(){
    cd $MY_MAINDIR
    mkdir -p final_inframe
    
    for segt in ${MY_INFRAME_SEGTS_ARRAY[@]}
    do
    pattern="${segt}_${MY_STRAIN}_${MY_DATASET}_${MY_ARTICLE}"
    Rscript ${MY_RSCRIPT2} \
    --alignment segments/${segt}_inframe/${pattern}_fastapairs.fasta  \
    --output final_inframe/${pattern}_inframe.fasta
    done
    }

## remove intermediary folders and files 
reorganize_directory_fun(){
    cd $MY_MAINDIR
    ## removing temporary directories 
    rm -r reformated
    rm -r sanitized
    rm -r segments_files
    ## remove temporary files
    rm ${MY_ARTICLE}_${MY_STRAIN}_${MY_DATASET}.fasta
    }

## wrapper running 
wrapper_run_fun_NVI(){
    # only done in first time
    rename_files_fun
    remove_gaps_fun
    # only for NVI
    reformating_NVI_headers_fun
    concat_reformated_fun
    create_segments_files_fun
    concatenate_segments_files_fun
    vsearch_inframe_fun
    final_inframe_fun
    reorganize_directory_fun
}


## to run if formatting problem - windows endings
## sed -i 's/\r//' wrapping_wrangling_code.sh 

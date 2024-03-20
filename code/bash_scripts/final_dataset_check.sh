#!/bin/bash


## sanitizing - final check removing gaps and Ns 
remove_gaps_check_fun(){
    ## $1 is the file argument
    conda activate seqkit

    mv $1 tempX.fasta
    seqkit seq -g -G "- N n " -o $1 tempX.fasta
    rm tempX.fasta

    conda deactivate
    }

## to run if formatting problem - windows endings
## sed -i 's/\r//' final_dataset_check.sh


vsearch_filter_fun(){
    
    ## $1 is DB
    ## $2 is file
    ## $3 is id
    ## $4 is the prefix for outfile 

    conda activate vsearch
    mkdir -p vsearch_filter 
    
    ## creating segments in frame
    vsearch  --db $1 --usearch_global $2 \
    --id $3 --iddef 3 \
    --userout vsearch_filter/${4}_userout.tsv \
    --userfields "query+target+alnlen+mism+opens+exts+gaps+qlo+qhi+tlo+thi+qs+ts+id0+id1+id2+id3+id4" \
    --maxhits 1 \
    --alnout vsearch_filter/${4}_alignment.aln \
    --fastapairs vsearch_filter/${4}_fastapairs.fasta \
    --matched vsearch_filter/${4}_matched.fasta \
    --notmatched vsearch_filter/${4}_notmatched.fasta \
    --log vsearch_filter/${4}_vsearch.log  --notrunclabels
    
    ## adding the header line to go faster
    sed -i '1 i query\ttarget\talnlen\tmism\topens\texts\tgaps\tqlo\tqhi\ttlo\tthi\tqs\tts\tid0\tid1\tid2\tid3\tid4\t' vsearch_filter/${4}_userout.tsv

    conda deactivate 

    }

  # --maxaccepts 100 --maxrejects 100 \

  remove_duplicates_seq_fun(){

    ## $1 is the file argument
    ## by sequence not by name 
    conda activate seqkit

    id=$(echo $1 | sed -e "s#.fasta##" )
    seqkit rmdup -si ${1}  -D ${id}_dup_list >  ${id}_seqnodup.fasta
    
    conda deactivate

    grep ">" ${id}_seqnodup.fasta | wc -l

    }

  remove_duplicates_name_fun(){

    ## $1 is the file argument
    ## by sequence not by name 
    conda activate seqkit

    id=$(echo $1 | sed -e "s#.fasta##" )
    seqkit rmdup -n $1 > ${id}_nonamedub.fasta 
    
    conda deactivate

    grep ">" ${id}_nonamedub.fasta | wc -l

    }
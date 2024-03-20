# Sea Eagle log - Phylogeny

## Organisation
Pilot project folder: `\\vetinst.no\dfs-felles\Felles02\FAG\Landdyr\Vilt\Prosjekter\WGS-AI`
- File : `overview_genotypes_norway_samples.xlsx` - Genotypes

## Background

> phylogeny has to be done similar to [Grant et al. 2022](https://www.mdpi.com/2306-7381/9/7/344)
- they used a ==referemce based approach to get the complete genomes==
- phylogenetic trees: using sequence of each individual genes segments separately
    - HA
    - NA 
    - They splitted by types : H5Ny and focused on the H5Nx (at least what is shown)
- collected additional sequences in GenBank: top 100 homologous sequences available
- ML tree using mega XI - boostrap analysis 2000 replicates 

## Get the assemblies from Thomas
- [x] those of sufficient quality
    - Report - those that were suitable for assembly
    - see file: [20230809_Sea_Eagle_evfi.xlsx]

```bash
# Assemblies in  /cluster/projects/nn9305k/active/thhaverk/WGS_AI/results/04_spades_asm/influenza_reads_asm
cd /cluster/projects/nn9305k/active/evezeyl/projects/AI/pilot/sea_eagle/assemblies
THDIR="/cluster/projects/nn9305k/active/thhaverk/WGS_AI/results/04_spades_asm/influenza_reads_asm"

for folder in $(ls -d $THDIR/*.asm)
do  
    id=$(echo $folder | sed -e "s#^.*/##g" | sed -e "s#_.*spades.asm##g")
    #echo $id
    cp $folder/contigs.fasta $id.fasta
done
```



## Separate Assemblies into segments
- [ ] We need to reconstruct the phylogeny per segment
- [ ] The contigs need to be oriented in the same order

Trying directly with vsearch. Make a reference database per segment:
- HA and NA
- include Cathrine reference the H5N1 goose_guangdong_1996  -> file [EPI_ISL_1254*.fasta]
- “BB genotype” is this: A/gull/France/22P015977/2022-like -> file 
- download from GISAID 2023/08/09


```bash
```

## Additional data - homogous of interest ? 
See file:  [20230809_Sea_Eagle_evfi.xlsx]

- [ ] #todo : Talk to Cathrine 
    - time period, Russia and Northern... Influenza season
    - Aslo eg. sea-egle host / wild birds
- [ ] collect GISAID references for H5N1 and H5N5 to include in the phylogeny
- [ ] Verify sequence quality of GISAID sequences -> see previous AI trial 
- [x] reference sequence that Cathrine uses form mapping: referansen A_goose_Guangdong/199 
- [ ] genotypes references 

## Multiple sequence alignment for the selected segments
We want a condon based alignment.
- [ ] Should/can we do H5N5 and H5N1 together or should we separate both ? 
    - That would be best together then we might gain information on H5Nx

Software candidates to perfor the alignements 
<!-- add a chat with Bjørn about that-->

Need to have the frame start. 

1. Mega - is supposed to perform well, but cannot be automated easily, unless all is perfect (then can likely use it with the command line)
2. MACSE - 
3. [Muscle](http://www.drive5.com/muscle/muscle_userguide3.8.html) - there should be an option to perform an alignment, correct it and then use it as guide afterwards
4.  (?mafft) should also be possible to add 

```bash
```

## Phylogenetic analysis with ALPPACA

- [ ] Consideration for GAPS and incomplete sequences, how to treat them. 
    - We need to remove if some sequences have too short sequences (usually works if > 50% longest, depending)

```bash
```
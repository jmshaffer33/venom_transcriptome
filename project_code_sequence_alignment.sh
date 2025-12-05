#!/bin/bash

#king cobra
#Terminal comands for king cobra dataset

# ran QC on RNA-seq samples using FastQC
fastqc SRR1821260_1.fastq SRR1821260_2.fastq
# didnt get any adapter sequences, so we jumped straght to alignment to the reference genome

# Using HISAT2
# reference genome: GCA_000516915.1_OphHan1.0_genomic.fna
# indexed:
hisat2-build GCA_000516915.1_OphHan1.0_genomic.fna OpHan_genome_index

# align using hisat, we have paired end sequenes for the transcripts
hisat2 -p 3 -x OpHan_genome_index -1 SRR1821260_1.fastq -2 SRR1821260_2.fastq -S aligned_OpHan.sam
# Results:
# 26140286 reads; of these:
# 26140286 (100.00%) were paired; of these:
# 7996760 (30.59%) aligned concordantly 0 times
# 17832142 (68.22%) aligned concordantly exactly 1 time
# 311384 (1.19%) aligned concordantly >1 times
# ----
# 7996760 pairs aligned concordantly 0 times; of these:
# 765211 (9.57%) aligned discordantly 1 time
# ----
# 7231549 pairs aligned 0 times concordantly or discordantly; of these:
# 14463098 mates make up the pairs; of these:
# 8970456 (62.02%) aligned 0 times
# 5114683 (35.36%) aligned exactly 1 time
# 377959 (2.61%) aligned >1 times
# 82.84% overall alignment rate
# Not super good numbers, but since this is not a model organism we also cant know for sure.

samtools view -bS aligned_OpHan.sam -o aligned_OpHan.bam

# convert to a bam file
samtools view -q 30 -c aligned_OpHan.bam
# know how may reads aligned with a quality score hgher than 30, combine view command with q30 and -c o count.

# For more info: https://hbctraining.github.io/Intro-to-rnaseq-hpc-O2/lessons/04_alignment_quality.html
# How many reads are unmapped? 
samtools view -f 4 -c aligned_OpHan.bam

#sort the bam file before indexing: 
samtools sort -o sorted_OpHan.bam aligned_OpHan.bam

# index the bam file to view on IGV:
samtools index aligned_sorted_OpHan.bam

# run featurecounts to get expression data
conda install -c bioconda subread (install featurecounts)
# GFF includes exons, but GTF is also fine. Start off with GFF.
featureCounts -p -t exon -g gene_id -a snake_venom/ncbi_dataset/data/GCA_000516915.1/genomic.gtf -o gtf_counts.txt aligned_sorted_OpHan.bam
# Results: 
# Status aligned_sorted_OpHan.bam
# Assigned 13240489
# Unassigned_Unmapped 8970456
# Unassigned_Read_Type 0
# Unassigned_Singleton 0
# Unassigned_MappingQuality 0
# Unassigned_Chimera 0
# Unassigned_FragmentLength 0
# Unassigned_Duplicate 0
# Unassigned_MultiMapping 2330297
# Unassigned_Secondary 0
# Unassigned_NonSplit 0
# Unassigned_NoFeatures 28992366
# Unassigned_Overlapping_Length 0
# Unassigned_Ambiguity 76534
# ~



# naja naja
#Terminal commands for naja-naja dataset

prefetch -v SRR8754988
fasterq-dump SRR8754988
fastqc SRR8754988.fastq
open SRR8754988_fastqc.html
#Looks fine, no adapter sequences
hisat2-build ncbi_dataset_naja/ncbi_dataset/data/GCA_009733165.1
hisat2-build ncbi_dataset_naja/ncbi_dataset/data/GCA_009733165.1/GCA_009733165.1_Nana_v5_genomic.fna naja_genome_index
hisat2 -x naja_genome_index -U SRR8754988.fastq -S aligned_naja.sam
#results from hisat2 command:
~/QBB_Project/naja_naja hisat2 -x naja_genome_index -U SRR8754988.fastq -S aligned_naja.sam
# 29551786 reads; of these:
#   29551786 (100.00%) were unpaired; of these:
#     9882057 (33.44%) aligned 0 times
#     16080799 (54.42%) aligned exactly 1 time
#     3588930 (12.14%) aligned >1 times
# 66.56% overall alignment rate
samtools view -bS aligned_naja.sam -0 aligned_naja.bam
amtools sort -o sorted_naja.bam aligned_naja.bam
samtools index sorted_naja.bam
#Looks good on IGV
featurecounts -t exon -g gene_id -a /Users/cmdb/QBB_Project/naja_naja/ncbi_dataset_naja/ncbi_dataset/data/GCA_009733165.1/genomic.gtf -o naja_gtf_counts.txt sorted_naja.bam
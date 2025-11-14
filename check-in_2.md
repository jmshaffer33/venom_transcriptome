# Venom_transcriptome Project Check-in 2

## Questions
### 1. How you’ve addressed prior feedback 
Feedback from Sadhana said that our progress looked good; we met Thurs Nov 13 to discuss the sequence alingment we did for Check-in 1 and next steps.
Clayton also left us a comment suggesting that we use a colubrid reference genome of a rear-fang venemous snake, proposing the Western Hognose (*Heterodon nasicus*) for its similar habitat distribution to *Boiga irregularis*. While it's a really good idea, I can only seem to find the RNA-sequencing data for the venom transcriptome, and not a whole genome sequence needed for use as a reference genome. I've attached the link to the data and reference number, but I just don't think its what we're looking for unfortunately. In our final presentation we could list this difficulty finding an appropriate reference genome as a limitation. 

***Heterodon nasicus***\
Transcriptome: SRR12802479   
https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=SRR12802479&display=metadata 

### 2. New progress since last submission 
Following the histat2 sequence alingment, we noted an 82.84% overall alignment rate. This number is surprisingly low, with usual alingment rates >90%. This may be due to the the king cobra's identity as a non-model organism and its therefore minimal previous characterization. Discussion with Sadhana hypothesized that this lower alignment rate may be due to either of two factors:   
1. Incomplete sequencing coverage 
2. Incomplete annotation coverage
While it is likely that incomplete sequencing coverage contributed to our lower alingment rate as the RNA-seq data only covered the venom transcriptome, a more highly specialized tissue, and thereby providing less coverage of other important snake genes, I also believe that incomplete annotation coverage is probably playing a role. In the original paper, the authors clasify their identified genes as either toxin or non-toxin transcripts. Of their total 68472 transcripts 39888 transcripts were unidentified (58.2%), 28456 were non-toxin (41.6%) and 128 were toxin (0.19%). The large proportion of unidentified genes may be bringing alingment rate down. 

#### Coding Progress
All completed code!  

#### ran QC on RNA-seq samples using FastQC   
fastqc SRR1821260_1.fastq SRR1821260_2.fastq  
#### didnt get any adapter sequences, so we jumped straght to alignment to the reference genome   
Using HISAT2  
#### reference genome: GCA_000516915.1_OphHan1.0_genomic.fna  
#### indexed:   
hisat2-build GCA_000516915.1_OphHan1.0_genomic.fna OpHan_genome_index      
#### align using hisat, we have paired end sequenes for the transcripts   
hisat2 -p 3 -x OpHan_genome_index -1 SRR1821260_1.fastq -2 SRR1821260_2.fastq -S aligned_OpHan.sam  
Results:  
q -S aligned_OpHan.sam   
26140286 reads; of these:  
  26140286 (100.00%) were paired; of these:  
    7996760 (30.59%) aligned concordantly 0 times   
    17832142 (68.22%) aligned concordantly exactly 1 time   
    311384 (1.19%) aligned concordantly >1 times   
    ----   
    7996760 pairs aligned concordantly 0 times; of these:    
      765211 (9.57%) aligned discordantly 1 time    
    ----    
    7231549 pairs aligned 0 times concordantly or discordantly; of these:    
      14463098 mates make up the pairs; of these:    
        8970456 (62.02%) aligned 0 times    
        5114683 (35.36%) aligned exactly 1 time    
        377959 (2.61%) aligned >1 times    
82.84% overall alignment rate   
Not super good numbers, but since this is not a model organism we also cant know for sure.    
samtools view -bS aligned_OpHan.sam -o aligned_OpHan.bam    
#### convert to a bam file     
samtools view -q 30 -c aligned_OpHan.bam    
#### know how may reads aligned with a quality score hgher than 30, combine view command with q30 and -c o count.   
For more info: https://hbctraining.github.io/Intro-to-rnaseq-hpc-O2/lessons/04_alignment_quality.html    
How many reads are unmapped? samtools view -f 4 -c aligned_OpHan.bam   
#sort the bam file before indexing: samtools sort -o sorted_OpHan.bam aligned_OpHan.bam   
#### index the bam file to view on IGV:    
samtools index aligned_sorted_OpHan.bam    
#### run featurecounts to get expression data   
conda install -c bioconda subread (install featurecounts)    
GFF includes exons, but GTF is also fine. Start off with GFF.   
featureCounts -p -t exon -g gene_id -a snake_venom/ncbi_dataset/data/GCA_000516915.1/genomic.gtf -o gtf_counts.txt aligned_sorted_OpHan.bam     
Status  aligned_sorted_OpHan.bam    
Assigned        13240489  
Unassigned_Unmapped     8970456  
Unassigned_Read_Type    0   
Unassigned_Singleton    0   
Unassigned_MappingQuality       0   
Unassigned_Chimera      0   
Unassigned_FragmentLength       0    
Unassigned_Duplicate    0   
Unassigned_MultiMapping 2330297   
Unassigned_Secondary    0   
Unassigned_NonSplit     0     
Unassigned_NoFeatures   28992366    
Unassigned_Overlapping_Length   0    
Unassigned_Ambiguity    76534      
~       

### 3. Project Organization  
Project organization has stayed the same since the last check-in. To reiterate:   
Lina has all the code and resultant files. For check-ins, she sends me a copy of the code, which I've include above.     
Jessica writes the check-ins and pushes the compleded assignments to the github once completed.    
We meet together to dicuss next steps, and will do so again to annotate the toxin-genes, work on the rear-fanged snake figure, and the final project presentation (Fri 12/5).   

### 4. Struggles you are encountering and questions you would like advice on     
Our direct next step is to match the annotations with the genes identifid at the end of the featurecounts analysis. While I've identified the annotations for the toxin genes from the RNA-seq paper, becasue there should be 128 genes, we will likely have code a bit to match them up with their gene name/protein product. We could also use the GTF annotation file of the whole genome sequencing, mount the identifiers and leftjoin the charts together to match up counts with annotations. Ideally we would not need to look look manually through the genes to identify toxins, and construct the subsequent R histogram. (If we could get it to run, genome annotation in R could be performed using BioConductor).     

Based on what other groups are completing, I unforutnately think we're going to have to do our reach goal and run the analysis/make the histogram for rear-fanged snakes too. So additional advice on that would be helpful too!      

And when it's time to make the slide show for the presentation, we would very much appreciate your help in outlining slides! So far there are very little guidelines as to what should be included in the final presentation, so any advice would be very much appreciated!       



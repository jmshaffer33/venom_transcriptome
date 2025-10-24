# Venom_transcriptome Project Check-in 1

## Questions
### 1. How you’ve addressed prior feedback 
Prior feadback was super kind! So thus far there was not much to address, just to keep moving forwards and accomplishing the goals we have planned. Lina has performed all of the coding thus far, and hopefully we are on our way towards venom transcriptome sequence alignment. To accomplish our reach goal, I (Jess) identified a reference genome for a Colubrid family snake of a different species (corn snake, species of North American rat snake) that can be used with the Rokyta et al 2014 *Boiga irregularis* data.  

### 2. New progress since last submission 
Identified Colubrid whole genome
***Pantherophis guttatus*** **(corn snake)**\
Whole genome sequencing: SRA SRR32257721\
https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=SRR32257721&display=metadata/  
Can be used for reach goal comparison figure, front-fanged snake vs rear-fanged snake venom transcriptome 

#### Coding Progress
Ran QC on RNA-seq samples using FastQC  
fastqc SRR1821260_1.fastq SRR1821260_2.fastq  
Didnt get any adapter sequences, so we jumped straght to alignment to the reference genome  
Using HISAT2   
Reference genome: GCA_000516915.1_OphHan1.0_genomic.fna   
Indexed:  hisat2-build GCA_000516915.1_OphHan1.0_genomic.fna OpHan_genome_index   
hisat2 -p 3 -x OpHan_genome_index -1 SRR1821260_1.fastq -2 SRR1821260_2.fastq -S aligned_OpHan.sam   
samtools view -bS aligned_OpHan.sam -o aligned_OpHan.bam #convert to a bam file   
samtools view -q 30 -c aligned_OpHan.bam # know how may reads aligned with a quality score hgher than 30, combine view command with q30 and -c o count.   
For more info: https://hbctraining.github.io/Intro-to-rnaseq-hpc-O2/lessons/04_alignment_quality.html    
How many reads are unmapped? samtools view -f 4 -c aligned_OpHan.bam    
#sort the bam file before indexing: samtools sort -o sorted_OpHan.bam aligned_OpHan.bam    
#Index the bam file to view on IGV:  
samtools index aligned_sorted_OpHan.bam   

### 3. Project Organization  
Right now, Lina has all of the code and a majority of the files (SAM, BAM, fastq, fna). I performed the intitial fastqc analysis and have shared the results with her as needed. The github respository recieves files from the qb25_project folder on my computer, so she has typed up a summary for me (which I've included above). The README and check-in markdown files are on my computer, and I push everything to the repository for submission. We may need to streamline the process as the project gets more complicated/generates more files, but for now this works! 

### 4. Struggles you are encountering and questions you would like advice on     
I just want to make sure that we're on the right path before we get too far along...  
Did we complete the sequence alignment correct thus far?   
Have we mapped everything correctly, and interpreted the fastqc results as expected?  
Is the data appropriately sorted and indexed? 

Also, what is the direct next step? Is it data visualization in R, or are there additional alignment and processing steps? 
Ideally we generate this pipeline so we can easily push the Colubrid data through for the front-fang vs rear-fang comparison, but we must make sure everything works first! 

It probably would be a good idea to scheule a meeting to go over our progress as a trio! To be discussed more in class! 

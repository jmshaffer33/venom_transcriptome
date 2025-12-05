setwd("/Users/cmdb/QBB_Project/important_files")
library(tidyverse)

# king cobra
annotation_file_kingcobra <- read_delim("genomic_kingcobra.gtf", skip = 3, col_names = FALSE) 

toxin_gtf_kingcobra <- annotation_file_kingcobra %>% 
  filter(grepl("toxin", X9) | grepl("venom", X9) | grepl("opharin", X9)|grepl("phospholipase", X9)| grepl("Zinc metalloproteinase", X9) | grepl("Kunitz inhibitor II", X9)| grepl("L-amino-acid oxidase", X9)| grepl("Ophiophagus venom factor", X9)| 
                 grepl("Natriuretic peptide Na-NP", X9)| grepl("SVSP thrombin-like serine protease ", X9)| grepl("kallikrein-Phi1 ", X9)| grepl("hypothetical protein L345_15265, partial", X9)
               | grepl("Cystatin-C", X9) | grepl("phosphodiesterase 1 ", X9) | grepl("c-type lectin ", X9)
  ) %>% 
  filter(X3 == "transcript")
toxin_gtf_kingcobra <- toxin_gtf_kingcobra%>% 
  separate_wider_delim(X9, delim = ";", names_sep = "", too_few = "debug") %>% 
  dplyr::rename(Geneid = "X91") %>% 
  mutate(Geneid = gsub("gene_id \"", "", Geneid), Geneid = gsub("\"", "", Geneid))
genes <- (toxin_gtf_kingcobra$Geneid)



annotation_file_kingcobra <- annotation_file_kingcobra %>% 
  separate_wider_delim(X9, delim = ";", names_sep = "", too_few = "debug") %>% 
  dplyr::rename(Geneid = "X91") %>% 
  mutate(Geneid = gsub("gene_id \"", "", Geneid), Geneid = gsub("\"", "", Geneid))


gtf_counts_kingcobra <- read_delim("gtf_counts.txt", skip = 1, col_names = TRUE) %>% 
  mutate(aligned_sorted_OpHan.bam = as.numeric(aligned_sorted_OpHan.bam))
counted_transcripts <- sum(gtf_counts_kingcobra$aligned_sorted_OpHan.bam)

#total transcripts 13240489
#calculate %
gtf_counts_kingcobra <- gtf_counts_kingcobra %>%
mutate(percent_counts = aligned_sorted_OpHan.bam/counted_transcripts * 100) 
counts_data <- gtf_counts_kingcobra %>% 
  filter(Geneid %in% genes)
#counts_data contains the %trascripts per gene

joined_file_kingcobra <- left_join(annotation_file_kingcobra, gtf_counts_kingcobra, by = "Geneid")


plot <- ggplot(counts_data, aes(x = fct_reorder(Geneid, percent_counts, .desc = TRUE),
                                y = percent_counts))+
  geom_bar(stat = "identity", color = "lightpink", fill = "deeppink") +
  labs(title = "% of Transcripts Per Gene",
       x = "Genes",
       y = "% of Transcripts") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 6, angle = 90, vjust = 0.5, hjust = 1))
plot
ggsave("histogram_king_cobra.png", plot = plot, width = 10, height = 6, dpi = 300)



#106 toxin genes
#18445 genes total(from wc of king cobra feature counts)
#28 toxin genes

kingcobra_pie <- tribble(
  ~Category,                 ~Count,
  "Toxin",   28,
  "Non-toxin",     18417,
)
cb_palette <- c(
  "Toxin" = "lightpink",
  "Non-toxin" = "deeppink"
)
kingcobra_pie <- ggplot(kingcobra_pie, aes(x = "", y = Count, fill = Category)) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  scale_fill_manual(values = cb_palette) +
  theme_void() +
  labs(fill = "Category", 
       title = "Ophiophagus hannah Proportion of Toxin Genes")
kingcobra_pie


# naja naja
annotation_file_naja <- read_delim("genomic_naja.gtf", skip = 3, col_names = FALSE)

toxin_gtf_naja <- annotation_file_naja %>% 
  filter(grepl("toxin", X9) | grepl("venom", X9) | grepl("opharin", X9)|grepl("phospholipase", X9)| grepl("Zinc metalloproteinase", X9) | grepl("Kunitz inhibitor II", X9)| grepl("L-amino-acid oxidase", X9)| grepl("Ophiophagus venom factor", X9)| 
           grepl("Natriuretic peptide Na-NP", X9)| grepl("SVSP thrombin-like serine protease ", X9)| grepl("kallikrein-Phi1 ", X9)| grepl("hypothetical protein L345_15265, partial", X9)
         | grepl("Cystatin-C", X9) | grepl("phosphodiesterase 1 ", X9) | grepl("c-type lectin ", X9)
  ) %>% 
  filter(X3 == "transcript")
toxin_gtf_naja <- toxin_gtf_naja %>% 
  separate_wider_delim(X9, delim = ";", names_sep = "", too_few = "debug") %>% 
  dplyr::rename(Geneid = "X91") %>% 
  mutate(Geneid = gsub("gene_id \"", "", Geneid), Geneid = gsub("\"", "", Geneid))
genes_naja <- (toxin_gtf_naja$Geneid)


gtf_counts_naja <- read_delim("naja_gtf_counts.txt", skip = 1, col_names = TRUE) %>% 
  mutate(sorted_naja.bam = as.numeric(sorted_naja.bam))
counted_transcripts <- sum(gtf_counts_naja$sorted_naja.bam)
#naja counted transcripts = 641968 

#calculate %
gtf_counts_naja<- gtf_counts_naja %>%
  mutate(percent_counts = sorted_naja.bam/counted_transcripts * 100) 
counts_data <- gtf_counts_naja %>% 
  filter(Geneid %in% genes_naja)
#counts_data contains the %trascripts per gene

naja_plot <- ggplot(counts_data, aes(x = fct_reorder(Geneid, percent_counts, .desc = TRUE),
                                y = percent_counts))+
  geom_bar(stat = "identity", color = "purple", fill = "purple") +
  labs(title = "% of Transcripts Per Gene",
       x = "Genes",
       y = "% of Transcripts") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 6, angle = 90, vjust = 0.5, hjust = 1))
naja_plot
ggsave("histogram_naja.png", plot = naja_plot, width = 10, height = 6, dpi = 300)

joined_file_naja <- left_join(annotation_file_naja, gtf_counts_naja, by = "Geneid")

write.table(joined_file_naja, file = "joined_file_naja.tsv", sep = "\t", row.names = FALSE)

#138 toxin genes
#23071 genes total (from wc of naja feature counts file)
#38 toxin genes

naja_pie <- tribble(
  ~Category,                 ~Count,
  "Toxin",   38,
  "Non-toxin",     23033,
)
cb_palette <- c(
  "Toxin" = "purple",
  "Non-toxin" = "orchid"
)
naja_pie<- ggplot(naja_pie, aes(x = "", y = Count, fill = Category)) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  scale_fill_manual(values = cb_palette) +
  theme_void() +
  labs(fill = "Category", 
       title = "Naja naja Proportion of Toxin Genes")
naja_pie


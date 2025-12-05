setwd("/Users/cmdb/qb25_project")
library(tidyverse)
install.packages("ggtext")
library(ggtext)

# king cobra
annotation_file_kingcobra <- read_delim("genomic_kingcobra.gtf", skip = 3, col_names = FALSE) 

toxin_gtf_kingcobra <- annotation_file_kingcobra %>%
  filter(grepl("toxin", X9) | grepl("venom", X9) | grepl("opharin", X9)|grepl("phospholipase", X9)| grepl("Zinc metalloproteinase", X9) | grepl("Kunitz inhibitor II", X9)| grepl("L-amino-acid oxidase", X9)| grepl("Ophiophagus venom factor", X9)|
           grepl("Natriuretic peptide Na-NP", X9)| grepl("SVSP thrombin-like serine protease ", X9)| grepl("kallikrein-Phi1 ", X9)| grepl("hypothetical protein L345_15265, partial", X9)
         | grepl("Cystatin-C", X9) | grepl("phosphodiesterase 1 ", X9) | grepl("c-type lectin ", X9)) %>%
  filter(X3 == "transcript")
toxin_gtf_kingcobra <- toxin_gtf_kingcobra%>% 
  separate_wider_delim(X9, delim = ";", names_sep = "", too_few = "debug") %>% 
  dplyr::rename(Geneid = "X91") %>% 
  mutate(Geneid = gsub("gene_id \"", "", Geneid), Geneid = gsub("\"", "", Geneid))




annotation_file_kingcobra <- annotation_file_kingcobra %>% 
  separate_wider_delim(X9, delim = ";", names_sep = "", too_few = "debug") %>% 
  dplyr::rename(Geneid = "X91") %>% 
  mutate(Geneid = gsub("gene_id \"", "", Geneid), Geneid = gsub("\"", "", Geneid))

gtf_counts_kingcobra <- read_delim("gtf_counts.txt", skip = 1, col_names = TRUE)

joined_file_kingcobra <- left_join(annotation_file_kingcobra, gtf_counts_kingcobra, by = "Geneid")

#106 toxin genes
#18445 genes total(from wc of king cobra feature counts)
#42 toxin genes

kingcobra_pie <- tribble(
  ~Category,                 ~Count,
  "Toxin",   42,
  "Non-toxin",     18403,
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
       title = expression("Proportion of toxin genes across whole genome in")) 
kingcobra_pie


# naja naja
annotation_file_naja <- read_delim("genomic_naja.gtf", skip = 3, col_names = FALSE)

toxin_gtf_naja <- annotation_file_naja %>%
  filter(grepl("toxin", X9) | grepl("venom", X9) | grepl("opharin", X9)|grepl("phospholipase", X9)| grepl("Zinc metalloproteinase", X9) | grepl("Kunitz inhibitor II", X9)| grepl("L-amino-acid oxidase", X9)| grepl("Ophiophagus venom factor", X9)|
           grepl("Natriuretic peptide Na-NP", X9)| grepl("SVSP thrombin-like serine protease ", X9)| grepl("kallikrein-Phi1 ", X9)| grepl("hypothetical protein L345_15265, partial", X9)
         | grepl("Cystatin-C", X9) | grepl("phosphodiesterase 1 ", X9) | grepl("c-type lectin ", X9)) %>%
  filter(X3 == "transcript")
toxin_gtf_naja <- toxin_gtf_naja %>% 
  separate_wider_delim(X9, delim = ";", names_sep = "", too_few = "debug") %>% 
  dplyr::rename(Geneid = "X91") %>% 
  mutate(Geneid = gsub("gene_id \"", "", Geneid), Geneid = gsub("\"", "", Geneid))

gtf_counts_naja <- read_delim("naja_gtf_counts.txt", skip = 1, col_names = TRUE)

joined_file_naja <- left_join(annotation_file_naja, gtf_counts_naja, by = "Geneid")

write.table(joined_file_naja, file = "joined_file_naja.tsv", sep = "\t", row.names = FALSE)

#138 toxin genes
#23071 genes total (from wc of naja feature counts file)
#49 toxin genes

naja_pie <- tribble(
  ~Category,                 ~Count,
  "Toxin",   49,
  "Non-toxin",     23022,
)
cb_palette <- c(
  "Toxin" = "plum",
  "Non-toxin" = "purple"
)
naja_pie<- ggplot(naja_pie, aes(x = "", y = Count, fill = Category)) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  scale_fill_manual(values = cb_palette) +
  theme_void() +
  labs(fill = "Category", 
       title = "Proportion of toxin genes across whole genome in")
naja_pie


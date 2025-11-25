setwd("/Users/cmdb/qb25_project")
library(tidyverse)

annotation_file <- read_delim("genomic.gtf", skip = 3, col_names = FALSE) 
annotation_file <- annotation_file %>% 
  separate_wider_delim(X9, delim = ";", names_sep = "", too_few = "debug") %>% 
  dplyr::rename(Geneid = "X91") %>% 
  mutate(Geneid = gsub("gene_id \"", "", Geneid), Geneid = gsub("\"", "", Geneid))

gtf_counts <- read_delim("gtf_counts.txt", skip = 1, col_names = TRUE)

joined_file <- left_join(annotation_file, gtf_counts, by = "Geneid")

#L345_18579
#L345_00001
#18578 genes


#add scripts to github!
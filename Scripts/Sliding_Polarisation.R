# # # # # # # # # # # # # # # # # # # # # # # # # # 
# 		Individual Research Project 25/26         #
#    		Stickleback ChrI Inversion            #
#        		 PCA Polatisation                 #
# Authors - Christophe Patterson & Layla Meghjee  #
# # # # # # # # # # # # # # # # # # # # # # # # # # 

#library packages
library(readxl)
library(dplyr)

#setting working directory
setwd("/gpfs01/home/mbxlm9/Stickle/SlidingW")

#loading polarised sliding window pc1 scores 
sliding <- read.table("slidingpc1.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)


#correcting my missspelling 
names(sliding)[4] <- "Individual"

#creating name for each window
sliding$windowname <- paste0 (sliding$Start, sliding$End,sep = "_")

#importing  metadata
meta_file <- ("/gpfs01/home/mbxlm9/Stickle/metadata/inversion_meta.xlsx")

#loading meta in 
meta <- read_excel(meta_file, sheet = "template")

#keeping sample id and ecotype
meta_ecotype <- meta %>%
	select( sampleID, ecotype) %>%
	distinct(sampleID .keep_all = TRUE)

#joining ecotype info to sliding pca 
sliding <- sliding %>% 
		inner_join (meta_ecotype, by = c("Individual" = "sampleID"))

#transforming pca so axis is segregating populations in the same direction across windows
#copy pc1 data to a new scaled column
sliding$PC1_scaled <- sliding$PC1 

#define column to check and invert 
scale_cols <- c("PC1_scaled")

#compute sign for eaach window
#marine indvs as reference group

signs <- sliding %>%
	filter(ecotype == "marine") %>%
	group_by(windowname) %>%
	summarise( across(all_of(scale_cols), ~ sign(median (.x, na.rm = TRUE)), .names = "sign_{.col}"), .groups = "drop"))

#join sign info back to original data 
sliding <- sliding %>%
		inner_join(signs, by = "windowname") %>% 
		mutate(across(all_of(scale_cols), ~ ifelse(get(paste0("sign_", cur_column()) == -1, -.x, .x))) %>%
		select( -starts_with("sign_"))


#standarised polarised pc1 independently within each window
sliding <- sliding %>%
			group_by(windowname) %>%
			mutate(PC1_standardised = as.numeric(scale(PC1_scaled))) %>%
			ungroup()

#saving the table

write.table( sliding, "slidingpc1_polarised.txt", sep = "\t", row.names = FALSE, quote = FALSE)












# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#        Local PC1 Departure        #
#      Author - Layla Meghjee       #
# # # # # # # # # # # # # # # # # # #

#library packages 
library(readxl)
library(dplyr)

#setting directories
setwd("/gpfs01/home/mbxlm9/Stickle/SlidingW")
outdir <- "/gpfs01/home/mbxlm9/Stickle/plots"

#loding polarised sliding window pc1 scores
sliding <- read.table("slidingpc1_polarised.txt", header = TRUE, sep = "\t")

#correcting previous spelling error 
names(sliding)[4] <- "Individual"

#loding whole region pca scores
whole_pca <- read.table("/gpfs01/home/mbxlm9/Stickle/plots/basic_PCA_scores.txt", header = TRUE, sep = "\t")

#identifying marine individuals
marine_ids <- unique(sliding$Individual[sliding$ecotype == "marine"])

#finding direction of whole region PC1
whole_sign <- sign(median (whole_pca$PC1[whole_pca$Individual %in% marine_ids], na.rm = TRUE))

#polarising whole region PC1
if(whole_sign == -1) {
	whole_pca$Whole_PC1 <- -whole_pca$PC1}
else {
	whole_pca$Whole_PC1 <- whole_pca$PC1}

#standardising whole region pc1
whole_pca$Whole_PC1_standardised <- as.numeric(scale(whole_pca$Whole_PC1))

#adding whole region pc1 to sliding
sliding <- sliding %>%
			inner_join (whole_pca %>%
				select (Individual, Whole_PC1, Whole_PC1_standardised), by = "Individual")

#adding window correlations
sliding <- sliding %>%
			inner_join(window_correlations %>%
					select (Window, Correlation), by = "Window")

#calculating local pc1 departures 
sliding <- sliding %>%
			mutate ( Expected_PC1 = Correlation * Whole_PC1_standardised, 
					Absolute_Residual = abs(PC1_standardised - Expected_PC1),
					LowCorrelationWindow = Start >= 26190000 & Start <= 26220000) 

#calculating departure for each individual
individual_departure <- sliding %>%
		group_by (Individual) %>%
		summarise (Whole_PC1 = first (Whole_PC1), 
					LowCorr_MeanResidual = mean(Absolute_Residual[LowCorrelationWindow], na.rm = TRUE),
					Background_MeanResidual = mean(Absolute_Residual [!LowCorrelationWindow], na.rm = TRUE),
					Excess_Local_Departure = LowCorr_MeanResidual - Background_MeanResidual, .groups = "drop")


#loading metadata
meta <- readxls("/gpfs01/home/mbxlm9/Stickle/metadata/inversion_meta.xlsx", sheet = "template")

#keeping required info 
meta_dep <- meta %>%
			select(sampleID, ecotype, LocationCode) %>%
			distinct( sampleID, .keep_all = TRUE) %>%
			mutate( Environment = case_when (ecotype %in% c( "lake", "stream") ~ "Freshwater", ecotype == "marine" ~ "Marine", TRUE ~ "Unknown"),
					Region = case_when (
                LocationCode == "WA" ~ "West Atlantic",
                LocationCode == "EA" ~ "East Atlantic",
                LocationCode == "EP" ~ "East Pacific",
                LocationCode == "WP" ~ "West Pacific",
                TRUE ~ NA_character_ ) )				


#adding metadata
individual_departure <- individual_departure %>%
		inner_join(meta_dep, by = c("Individual" = "sampleID"))


#saving results
write.table (individual_departure, file = file.path, outdir "local_pc1_departure"), sep = "\t", quote = FALSE, row.name = FALSE) 









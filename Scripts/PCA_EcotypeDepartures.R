# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#      Ecotype Exception Check      #
#      Author - Layla Meghjee       #
# # # # # # # # # # # # # # # # # # #

#library packages 
library(readxl)
library(dplyr)

#loading metadata
meta <- readxls("/gpfs01/home/mbxlm9/Stickle/metadata/inversion_meta.xlsx", sheet = "template")

#loading whole region pca scores
whole_pca <- read.table("/gpfs01/home/mbxlm9/Stickle/plots/basic_PCA_scores.txt"), header = TRUE, sep = "\t", stringsAsFactors = FALSE)

#keeping metadata needed 
meta_eco <- meta %>%
			select(sampleID, ecyotype, LocationCode) %>%
			distinct(sampleID, .keep_all = TRUE)

#grouping into freshwater and marine 
meta_eco <- meta_eco %>%
	mutate( Environment = case_when(
		ecotype %in% c("lake", "stream") ~ "Freshwater",
		ecotype == "marine" ~ "Marine",
		TRUE ~ NA_character_))

#polarising whole region pc1 so marine median is postive
whole_sign <- sign(median(pca_eco$PC1 [pca_eco$Environment == "Marine"], na.rm = TRUE))
if(whole_sign == -1){
	pca_eco$Whole_PC1 <- -pca_eco$PC1}
else {
	pca_eco$Whole_PC1 <- pca_eco$PC1}

#removing unknown ecotyopes
pca_eco <- pca_eco %>%
		  filter( !is.na(Environment))

#givig each loc code full names
pca_eco <- pca_eco %>%
        mutate(
         Region = case_when (
                LocationCode == "WA" ~ "West Atlantic",
                LocationCode == "EA" ~ "East Atlantic",
                LocationCode == "EP" ~ "East Pacific",
                LocationCode == "WP" ~ "West Pacific",
                TRUE ~ NA_character_ ) )

#identifying opposite side individuals 
exceptions <- pca_eco %>%
			mutate (Exception = case_when(Environment == "Freshwater" & Whole_PC1 >0 ~ "Freshwater positive PC1",
						Environment == "Marine" $ Whole_PC1 <0 ~ "Marine Negative PC1",
						TRUE ~ NA_character_)) %>%
			filter( !is.na(Exception))

#full exception table 
exception_individuals <- exceptions %>%
	select( Individual, Exception, Environment, ecotype, LocationCode, Whole_PC1) %>%
	arrange (Exception, Region, LocationCode, Whole_PC1)

#saving 
write.table (exception_individuals, "/gpfs01/home/mbxlm9/Stickle/plots/EE_individual.txt", sep = "\t", quote = FALSE, row.names = FALSE)












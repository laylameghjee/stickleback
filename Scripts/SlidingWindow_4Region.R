# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#        4 Region PCA Plot          #
#      Author - Layla Meghjee       #
# # # # # # # # # # # # # # # # # # #

library(ggplot2)
library(readxl)
library(dplyr)

#setting working directory
setwd("/gpfs01/home/mbxlm9/Stickle/SlidingW")

#loading polarised sliding window pc1 scores 
sliding <- read.table("slidingpc1_polarised.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)


#correcting my missspelling 
names(sliding)[4] <- "Individual"

#importing  metadata
meta_file <- ("/gpfs01/home/mbxlm9/Stickle/metadata/inversion_meta.xlsx")

#loading meta in 
meta <- read_excel(meta_file, sheet = "template")

#loading whole region pca scores 
whole_pca <- read.table("/gpfs01/home/mbxlm9/Stickle/plots/basic_PCA_scres.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)

#keeping sample id and loc code 
meta_loc <- meta %>% 
		select( sampleID, LocationCode) %>%
		distinct(sampleID .keep_all = TRUE)


#givig each loc code full names
meta_loc <- meta_loc %>%
        mutate(
         Region = case_when (
                LocationCode == "WA" ~ "West Atlantic",
                LocationCode == "EA" ~ "East Atlantic",
                LocationCode == "EP" ~ "East Pacific",
                LocationCode == "WP" ~ "West Pacific",
                TRUE ~ NA_character_ ) )


#keeping individual and whole region pc1
whole_pc1 <- whole_pca %>%
	select(Individual, PC1) %>%
	rename(Whole_PC1 = PC1)

#merge sliding pca with metadata
sliding_4 <- sliding %>%
			 inner_join( meta_loc, by c("Individual" = "sampleID")) %>%
			 inner_join(whole_pc1, by = "Individual")


#setting region order 
sliding_4$Region <- factor( sliding_4$Region, levels = c( "West Atlantic", "East Atlantic", "East Pacific", "West Pacific"))

#creating individual order based on whole region pc1
individual_order <- sliding_4 %>%
	distinct(Individual, Region, Whole_PC1) %>%
	arrange(Region, Whole_PC1)

sliding_4$Individual <- factor(sliding_4$Individual, levels = individual_order$Individual)

#converting window start from bases to Mb
sliding_4$Position <- sliding_4$Start / 1000000


#creating heatmap
heatmap <- ggplot(sliding_4, 
	aes( x = Position, y = Individual, fill = PC1_standardised) ) +
	geom_tile() + scale_fill_gradient2(
	low = "blue",
	mid = "white",
	high = "red",
	midpoint = 0 ) +
	facet_grid( Region ~ .,
		scales = "free_y",
		space = "free_y") +
	labs ( title = "Sliding PCA across ChrI Candidate Region \n Separared by Ocean and Directional Regions",
		x = "Chromosome I Position (Mb)",
		y = "Individual",
		fill = "Standardised PC1") +
	theme_minimal() +
	theme ( plot.title = element_text(hjust =0.5, face = "bold", size = 14),
		panel.grid = element_blank(),
		axis.text.y = element_blank(),
		axis.ticks.y = element_blank(),
		strip.text.y = element_text(size=10),
		strip.background = element_rect (fill = "white", colour = "black") )

#saving heatmap
ggsave("sliding_4_PCA_heatmap.png",
	heatmap,
	width = 10,
	height = 20,
	dpi = 300)


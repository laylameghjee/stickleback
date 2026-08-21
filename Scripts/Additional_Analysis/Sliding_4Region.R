# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#        Sliding Window Plot        #
#          4 Region Split	        #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #

#library packages
library(ggplot2)
library(readxl)
library(dplyr)

#setting working directory
setwd("/gpfs01/home/mbxlm9/Stickle/SlidingW")

#loading in sliding window pc1 scores
sliding <- read.table("slidingpc1.txt", header = TRUE, sep ="\t")

#importing  metadata
meta_file <- ("/gpfs01/home/mbxlm9/Stickle/metadata/inversion_meta.xlsx")

#correcting my missspelling 
names(sliding)[4] <- "Individual"

#loading meta in 
meta <- read_excel(meta_file, sheet = "template")

#keeping sample id and loc code
meta_loc <- meta %>%
		select( sampleID, LocationCode) %>%
		distinct(sampleID, .keep_all = TRUE)

#giving loc codes full names
meta_loc <- meta_loc %>%
	mutate( Region = case_when(
		LocationCode == "WA" ~ "West Atlantic",
                LocationCode ==	"EA" ~ "East Atlantic",
                LocationCode ==	"WP" ~ "West Pacific",
                LocationCode ==	"EP" ~ "East Pacific",
		TRUE ~ NA_character_))

#merging pca w meta
sliding_4 <- sliding %>%
		inner_join( meta_loc, by = c("Individual" = "sampleID"))

#setting region order 
sliding_4$Region <- factor(sliding_4$Region, 
			levels = c("West Atlantic","East Atlantic", "West Pacific", "East Pacific"))

#converting window start from bases to Mb
sliding_4$Position <- sliding_4$Start / 1000000

#standardising pc1 witin each window 
sliding_4 <- sliding_4 %>%
	group_by(Window) %>%
		mutate(PC1_scaled = as.numeric(scale(PC1))) %>%
		ungroup()

#creating heatmap
heatmap <- ggplot(sliding_4, 
	aes( x = Position, y = Individual, fill = PC1_scaled) ) +
	geom_tile() + scale_fill_gradient2(
	low = "blue",
	mid = "white",
	high = "red",
	midpoint = 0 ) +
	facet_grid( Region ~ .,
		scales = "free_y",
		space = "free_y") +
	labs ( title = "Sliding PCA across chromosome I Inversion by ocean region",
		x = "Chromosome I position (Mb)",
		y = "Individual",
		fill = "Standardised PC1") +
	theme_minimal() +
	theme ( panel.grid = element_blank(),
		axis.text.y = element_blank(),
		axis.ticks.y = element_blank(),
		strip.txt.y = element_text(size=10),
		strip.background = element_rect (fill = "white", colour = "black") )

#saving heatmap
ggsave("sliding4_PCA_heatmap.png",
	heatmap,
	width = 10,
	height = 20,
	dpi = 300) 

#saving data used 
write.table(sliding_4, "slidingpc1_4region.txt", sep ="\t", quote = FALSE, row.names = FALSE) 

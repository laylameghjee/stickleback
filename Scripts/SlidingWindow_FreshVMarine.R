# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#        Sliding Window Plot        #
#     Freshwater vs Marine Split    #
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

#keeping sample id and eco type
meta_eco <- meta %>%
		select( sampleID, ecotype) %>%
		distinct(sampleID, .keep_all = TRUE)

#grouping into freshwater and marine 
meta_eco <- meta_eco %>%
	mutate( Environment = case_when(
		ecotype %in% c("lake", "stream") ~ "Freshwater",
		ecotype == "marine" ~ "Marine",
		TRUE ~ NA_character_))

#merging pca w meta
sliding_eco <- sliding %>%
		inner_join( meta_eco, by = c("Individual" = "sampleID"))

#setting  order 
sliding_eco$Environment <- factor(sliding_eco$Environment, 
			levels = c("Freshwater", "Marine"))

#converting window start from bases to Mb
sliding_eco$Position <- sliding_eco$Start / 1000000

#standardising pc1 witin each window 
sliding_eco <- sliding_eco %>%
	group_by(Window) %>%
		mutate(PC1_scaled = as.numeric(scale(PC1))) %>%
		ungroup()

#creating heatmap
heatmap <- ggplot(sliding_eco, 
	aes( x = Position, y = Individual, fill = PC1_scaled) ) +
	geom_tile() + scale_fill_gradient2(
	low = "blue",
	mid = "white",
	high = "red",
	midpoint = 0 ) +
	facet_grid( Environment ~ .,
		scales = "free_y",
		space = "free_y") +
	labs ( title = "Sliding PCA across chromosome I Inversion by ecotype",
		x = "Chromosome I position (Mb)",
		y = "Individual",
		fill = "Standardised PC1") +
	theme_minimal() +
	theme ( panel.grid = element_blank(),
		axis.text.y = element_blank(),
		axis.ticks.y = element_blank(),
		strip.text.y = element_text(size=10),
		strip.background = element_rect (fill = "white", colour = "black") )

#saving heatmap
ggsave("sliding_eco_PCA_heatmap.png",
	heatmap,
	width = 10,
	height = 20,
	dpi = 300)

#saving data used 
write.table(sliding_eco, "slidingpc1_eco.txt", sep ="\t", quote = FALSE, row.names = FALSE) 


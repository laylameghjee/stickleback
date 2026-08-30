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
sliding <- read.table("slidingpc1_polarised.txt", header = TRUE, sep ="\t")

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

#kloading whole region pca scores
whole_pca <- read.table("/gpfs01/home/mbxlm9/Stickle/plots/basic_PCA_scores.txt",
			header = TRUE, sep = "\t")

#adding ecotype to whole region pca
whole_pca <- whole_pca %>%
	inner_join(meta_eco %>%
						select(sampleID, ecotype),
						by = c("Individual" = "sampleID"))


#finding direction of whole region pc1
whole_sign <- sign(median( whole_pca$PC1[whole_pca$ecotype == "mmarine"], na.rm = TRUE))

#polarising whole region pc1 so marine median is +ve
if(whole_sign == -1) {
		whole_pca$Whole_PC1 <- -whole_pca$PC1 }
	else { 
		whole_pca$Whole_PC1 <- whole_pca$PC1 }

#keeping individual and whole region pc1
whole_pc1 <- whole_pca %>%
	select(Individual, Whole_PC1)


#merging pca w meta
sliding_eco <- sliding %>%
		inner_join( meta_eco, by = c("Individual" = "sampleID"))


#removing unknown ecotypes
sliding_eco <- sliding_eco %>%
	filter(!is.na(Environment))

#setting order of plot (groups)
sliding_eco$Environment <- factor(sliding_eco$Environment, levels = c("Freshwater", "Marine"))


#ordering individuals by their whole region pc1
individual_order <- sliding_eco %>%
	distinct(Individual, Environment, Whole_PC1) %>%
	arrange(Environment, Whole_PC1)


#setting individual order 
sliding_eco$Individual <- factor(sliding_eco$Individual, 
			levels = individual_order$Individual)

#converting window start from bases to Mb
sliding_eco$Position <- sliding_eco$Start / 1000000


#creating heatmap
heatmap <- ggplot(sliding_eco, 
	aes( x = Position, y = Individual, fill = PC1_standardised) ) +
	geom_tile() + scale_fill_gradient2(
	low = "blue",
	mid = "white",
	high = "red",
	midpoint = 0 ) +
	facet_grid( Environment ~ .,
		scales = "free_y",
		space = "free_y") +
	labs ( title = "Sliding PCA across ChrI Candidate Region by Ecotype",
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
ggsave("sliding_eco_PCA_heatmap.png",
	heatmap,
	width = 10,
	height = 20,
	dpi = 300)

#saving data used 
write.table(sliding_eco, "slidingpc1_eco.txt", sep ="\t", quote = FALSE, row.names = FALSE) 


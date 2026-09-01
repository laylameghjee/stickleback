# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
# PCA coloured by Sampling Location #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #

#library packages
library(ggplot2)
library(readxl)
library(dplyr)

#setting directories 
pca <- "/gpfs01/home/mbxlm9/Stickle/plots/basic_PCA_scores.txt"
meta <- "/gpfs01/home/mbxlm9/Stickle/metadata/rawg0214_Gasterosteus_aculeatus_TobiasPatterson_metadata.xlsx"
OUTDIR <- "/gpfs01/home/mbxlm9/Stickle/plots"

#loading pca scores
pca_scores <- read.table(pca, header = TRUE, sep = "\t")

#loading metadata
metadata <- read_excel(meta, sheet = "template", skip = 18, col_names = TRUE)
#keeping sample id and sampling location
meta_loc <- metadata %>%
	select(
	sampleID,
	location)

#combininb meta and pca
pca_loc <- pca_scores %>%
	inner_join (meta_loc,
	by = c("Individual" = "sampleID") )

#pca 

pca_loc_plot <- ggplot(
	data = pca_loc,
	aes ( x = PC1, y = PC2, colour = location) ) +
	geom_point( size = 2, alpha = 0.8) +
	labs(
	title = "PCA of chromosome I inversion region by sampling location",
	x = "PC1",
	y = "PC2",
	colour = "Sampling Location") +
	guides(	
	colour = guide_legend( ncol = 3, override.aes = list( size =3, alpha =1) ) ) 

#saving
ggsave(filename = file.path(OUTDIR,"pca_loc.png"),
	plot = pca_loc_plot,
	width = 14,
	height = 10,
	dpi = 300)

# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#        2 Region PCA Plot          #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #

library(ggplot2)
library(readxl)
library(dplyr)

#setting directories and files

pcafile <- "/gpfs01/home/mbxlm9/Stickle/plots/basic_PCA_scores.txt"
metadata <- "/gpfs01/home/mbxlm9/Stickle/metadata/inversion_meta.xlsx"
outdir <- "/gpfs01/home/mbxlm9/Stickle/plots"

#loading pca scores
pca_scores <- read.table(pcafile, header = TRUE, sep = "\t",stringsAsFactors = FALSE)

#loading metadata
meta <- read_excel(metadata, sheet = "template")

#keeping sample Id and loc code
meta_loc <- meta %>%
	select(
	sampleID,
	LocationCode) %>%
	distinct( sampleID, .keep_all = TRUE)

#combining east/west for each ocean into one 
meta_loc <- meta_loc %>%
	mutate(
	 Ocean = case_when (
		LocationCode %in% c("EA", "WA") ~ "Atlantic",
                LocationCode %in% c("EP", "WP") ~ "Pacific",
		TRUE ~ NA_character_ ) )

#merging pca scores with ocean 
pca_ocean <- pca_scores %>%
	inner_join(
	meta_loc,
	by = c("Individual" = "sampleID") )

		
#setting legend order so Atlantic appears first on plot
pca_ocean$Ocean <- factor(
	pca_ocean$Ocean,
	levels = c("Atlantic", "Pacific"))


#saving grouped pca scores for later 
write.table(pca_ocean,file = file.path( OUTDIR, "pca_scores_2region.txt"),sep = "\t",quote = FALSE, row.names = FALSE)

#plotting 
pca_ocean_plot <- ggplot(
	data = pca_ocean,
	aes( x= PC1, y = PC2, colour = Ocean) ) +
	geom_point( size = 2, alpha = 0.4) +
	scale_colour_manual(values = c("Atlantic" = "cadetblue2", "Pacific" = "firebrick1")) +
	labs(
	title = "Basic PCA of ChrI Candidate Region, \n Separated by Ocean Region, PC1 v PC2",
	x = "PC1",
	y = "PC2",
	colour = "Ocean") +
	theme_classic(base_size = 14) +
	theme( plot.title = element_text (hjust = 0.5, face = "Bold", size = 12.5, lineheight = 1.1),
		axis.title = element_text( size = 13),
		axis.text = element_text( size = 11))



#saving plot
ggsave(filename = file.path(
	outdir, "pca_2region.png"),
	plot = pca_ocean_plot,
	width = 8,
	height = 6,
	dpi = 600) 

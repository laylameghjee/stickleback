# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#  Faceted PCA - Sampling Location  #
#      Author - Layla Meghjee       #
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

#facet plot
pca_facet <- ggplot(data = pca_loc, aes( x = PC1, y = PC2)) +
	geom_point(size = 1.5, alpha = 0.8)+
	facet_wrap(~ location, ncol = 6) +
	labs( title = "PCA of chromosome I inversion region by sampling location", 
	x = "PC1", y = "PC2") +
	theme(
	strip.text = element_text(size = 7),
	axis.text = element_text(size = 7),
	axis.title = element_text(size = 10))

#saving 
ggsave(filename = file.path(OUTDIR,"pca_loc_facet.png"),
        plot = pca_facet,
        width = 18,
        height = 24,
        dpi = 300)

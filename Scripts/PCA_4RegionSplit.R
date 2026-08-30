# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#        4 Region PCA Plot          #
#      Author - Layla Meghjee       #
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

#givig each loc code full names
meta_loc <- meta_loc %>%
        mutate(
         Region = case_when (
                LocationCode == "WA" ~ "West Atlantic",
                LocationCode == "EA" ~ "East Atlantic",
                LocationCode == "EP" ~ "East Pacific",
                LocationCode == "WP" ~ "West Pacific",
                TRUE ~ NA_character_ ) )

#merging pca scores with ocean 
pca_ocean <- pca_scores %>%
        inner_join(
        meta_loc,
        by = c("Individual" = "sampleID") )

#setting legend order
pca_ocean$Region <- factor(
        pca_ocean$Region,
        levels = c("West Atlantic","East Atlantic", "East Pacific", "West Pacific"))


#saving grouped pca scores for later 
write.table(pca_ocean, file = file.path( OUTDIR, "pca_scores_4region.txt"), sep = "\t", quote = FALSE, row.names = FALSE)

#adding region counts to output file
print(table ( pca_ocean$Region, useNA = "ifany"))

#plotting 
pca_region_plot <- ggplot(
        data = pca_ocean,
        aes( x= PC1, y = PC2, colour = Region) ) +
        geom_point( size = 2, alpha = 0.8) +
        scale_colour_manual(values = c(
	"West Atlantic" = "dodgerblue", 
        "East Atlantic" = "cadetblue2",
	"East Pacific" = "red4",
        "West Pacific" = "firebrick1")) +          
	labs(
        title = "Basic PCA of ChrI Candidate Region, \n Separated by Ocean and Directional Regions, PC1 v PC2",
        x = "PC1",
        y = "PC2",
        colour = "Ocean Region") +
        theme_classic(base_size = 14) +
        theme( plot.title = element_text (hjust = 0.5, face = "Bold", size = 12.5, lineheight = 1.1),
                axis.title = element_text( size = 13),
                axis.text = element_text( size = 11))


#saving plot
ggsave(filename = file.path(
        outdir, "pca_4region.png"),
        plot = pca_region_plot,
        width = 8,
        height = 6,
        dpi = 600)

# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#       Ecotype by OCean PCA        #
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
meta_eco <- meta %>%
        select(
        sampleID,
        LocationCode) %>%
        distinct( sampleID, .keep_all = TRUE)

#grouping into freshwater and marine 
meta_eco <- meta_eco %>%
        mutate( Environment = case_when(
                ecotype %in% c("lake", "stream") ~ "Freshwater",
                ecotype == "marine" ~ "Marine",
                TRUE ~ NA_character_))

#grouping into atlantic and pacific 
meta_eco <- meta_eco %>%
        mutate(
         Region = case_when (
                LocationCode %in% c("WA", "EA") ~ "Atlantic",
                LocationCode %in% c("WP", "EP") ~ "Pacific",
                TRUE ~ NA_character_ ) )

#merging pca scores with meta 
pca_eco <- pca_scores %>%
        inner_join(
        meta_eco,
        by = c("Individual" = "sampleID") )

#sremoving unknown ecotypes
pca_eco <- pca_eco %>%
           filter ( !is.na(Environment), !is.na(Ocean))

#setting ecotype order
pca_eco$Environment <- factor(
        pca_eco$Environment,
        levels = c("Freshwater","Marine"))

#setting ocean order
pca_eco$Ocean <- factor(
        pca_eco$Ocean,
        levels = c("Atlantic","Pacific"))


#plotting 
pca_plot <- ggplot(
        data = pca_eco,
        aes( x= PC1, y = PC2, colour = Environment) ) +
        geom_point( size = 2, alpha = 0.8) +
        scale_colour_manual(values = c(
	"Freshwater" = "dodgerblue", 
        "Marine" = "cadetblue2")) +  
        facet_wrap ( ~Ocean, nrow =1) +       
	labs(x = "PC1",
        y = "PC2",
        colour = "Ocean Region") +
        theme_classic(base_size = 14) +
        theme(axis.title = element_text( size = 13),
                axis.text = element_text( size = 11),
                strip.text = element_text(size = 11, face = "bold"))


#saving plot
ggsave(filename = file.path(
        outdir, "pca_2regionbyocean.png"),
        plot = pca_region_plot,
        width = 8,
        height = 6,
        dpi = 600)

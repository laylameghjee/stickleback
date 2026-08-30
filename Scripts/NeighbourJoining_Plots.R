# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#      Neighbour Joining Plots      #
#      Author - Layla Meghjee       #
# # # # # # # # # # # # # # # # # # #

#library packages
library(ape)
library(readxl)
library(dplyr)

#setting files and directories
tree_file <- "/gpfs01/home/mbxlm9/Stickle/NJtree/ChrI_NJ_tree.rds"
meta_file <- "gpfs01/home/mbxlm9/Stickle/metadata/inversion_meta.xsls"
outdir <- "/gpfs01/home/mbxlm9/Stickle/NJtree"

#loading neighbour joining three
nj_tree <- readRDS(tree_file)

#ordering tree for clearer plotting
nj_tree <- laddersize (nj_tree)

#loading metadata 
meta <- readxls(meta_file, sheet = "template")

#keeping emtadata needed
meta_tree <- meta %>%
			select(sampleID, LocationCode, ecotype) %>%
			distinct (sampleID, .keep_all = TRUE)


#givig each loc code full names
meta_tree <- meta_tree %>%
        mutate(
         Region = case_when (
                LocationCode == "WA" ~ "West Atlantic",
                LocationCode == "EA" ~ "East Atlantic",
                LocationCode == "EP" ~ "East Pacific",
                LocationCode == "WP" ~ "West Pacific",
                TRUE ~ NA_character_ ) )


  #grouping into freshwater and marine 
meta_tree <- meta_tree %>%
	mutate( Environment = case_when(
		ecotype %in% c("lake", "stream") ~ "Freshwater",
		ecotype == "marine" ~ "Marine",
		TRUE ~ "Unknown"))

#matching metadata to tips
tip_meta <- data.frame( Individual = nj_tree$tip.label, stringsAsFactors = FALSE) %>%
			inner_join(meta_tree, by =c("Individual" = "sampleID"))

#setting region colouts
region_colours <- c("West Atlantic" = "dodgerblue", "East Atlantic" = "cadetblue2","East Pacific" = "red4","West Pacific" = "firebrick1")

#matching region colours to tree tips
tip_region_colour <- region_colours[as.character(tip_meta$Region)]
#setting unmatched samples to grey
tip_region_colour[is.na(tip_region_colour)] <- "grey50"

#setting ecotype colours 
ecotype_colours <- c("Freshwater" = "dodgerblue", "Marine" = "firebrick1", "Unknown" = "grey60")

#matching region colours to tree tips
tip_ecotype_colour <- ecotype_colours[as.character(tip_meta$Environment)]

#FIGURE 1 - ecotupe REGION
#plotting in base r
png (filename = file.path( outdir, "ChrI_NJ_ecotypetree.png"), width 4800, 4800, res = 600)
par( mar = c(1,1,4,1)) #graphical setting
plot(nj_tree, type = "fan", show.tip.label = FALSE, edge.color = "grey75", edge.width = 0.5)
tiplabels(pch = 16, col = tip_ecotype_colour, cex = 0.35)
title( main = "Neighbour-Joining Tree of ChrI Candidate Region, \n Separated by Ecotype", font.main = 2, cex.main = 1.2)
legend ("topright", legend = names(ecotype_colours), col = ecotype_colours, pch = 16, pt.cex = 1.2, bty = "n", title = "Ecotype", cex = 0.9)
dev.off()


#FIGURE 2 - geographic tree
#plotting in base r
png (filename = file.path( outdir, "ChrI_NJ_4region.png"), width 4800, 4800, res = 600)
par( mar = c(1,1,4,1)) #graphical setting
plot(nj_tree, type = "fan", show.tip.label = FALSE, edge.color = "grey75", edge.width = 0.5)
tiplabels(pch = 16, col = tip_ecotype_colour, cex = 0.35)
title( main = "Neighbour-Joining Tree of ChrI Candidate Region, \n Separated by Geographic Region", font.main = 2, cex.main = 1.2)
legend ("topright", legend = names(region_colours), col = region_colours, pch = 16, pt.cex = 1.2, bty = "n", title = "Region", cex = 0.9)
dev.off()
















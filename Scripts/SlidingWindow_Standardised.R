# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#  Standardised Sliding Window Plot #
#      Author - Layla Meghjee       #
# # # # # # # # # # # # # # # # # # #


#library packages
library(ggplot2)
library(dplyr)

#setting working directory
setwd("/gpfs01/home/mbxlm9/Stickle/SlidingW")

#loading in sliding window pc1 scores
sliding <- read.table("slidingpc1.txt", header = TRUE, sep ="\t")

#correcting my missspelling 
names(sliding)[4] <- "Individual"

#keeps individuals in order
sliding$Individual <- factor(sliding$Individual,
         levels = unique(sliding$Individual))

#converting window start from bases to Mb
sliding$Position <- sliding$Start / 1000000

#standardising pc1 within each window
#allows for better direct comparison across chrom
sliding <- sliding %>%
	group_by(Window) %>%
	mutate(PC1_scaled = as.numeric(scale(PC1))) %>%
	ungroup()

#creating heatmap
heatmap_scaled <- ggplot(sliding,
        aes( x = Position, y = Individual, fill = PC1_scaled) ) +
        geom_tile() + scale_fill_gradient2(
        low = "cadetblue2",
        mid = "white",
        high = "firebrick1",
        midpoint = 0 ) +
        labs ( title = "Standardised Sliding PCA (PC1) across CHrI Candidate Region, \n Individuals Ungrouped",
                x = "Chromosome I Position (Mb)",
                y = "Individual",
                fill = "Standardised PC1") +
        theme_classic(base_size = 14) +
        theme ( plot.title = element_text( hjust = 0.5, face = "bold", size = 12.5, linehight = 1.1),
                axis.title(element_text(size = 13),
                axis.text.x = element_text(size =11),
                axis.text.y = element_blank(),
                axis.ticks.y = element_blank(),
                legend.title = element_text(size = 12),
                legend.text = element_text(size = 11) )

#saving heatmap
ggsave("sliding_PCA_heatmap_standardised.png",
        heatmap_scaled,
        width = 10,
        height = 20,
        dpi = 600)

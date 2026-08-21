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
        low = "blue",
        mid = "white",
        high = "red",
        midpoint = 0 ) +
        labs ( title = "Standardised Sliding PCA across chromosome I Inversion",
                x = "Chromosome I position (Mb)",
                y = "Individual",
                fill = "Standardised PC1") +
        theme_minimal() +
        theme ( panel.grid = element_blank(),
                axis.text.y = element_text(size = 2),
                axis.ticks.y = element_blank() )

#saving heatmap
ggsave("sliding_PCA_heatmap_standardised.png",
        heatmap_scaled,
        width = 10,
        height = 20,
        dpi = 300)

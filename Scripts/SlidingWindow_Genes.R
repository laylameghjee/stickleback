# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#       Sliding Window Plot         #
#       With Gene Annotations       #
#       ChrI 26.15 - 26.30 Mb       #
#      Author - Layla Meghjee       #
# # # # # # # # # # # # # # # # # # #


#library packages 
library(ggplot2)
library(dplyr)

#setting directories
setwd("/gpfs01/home/mbxlm9/Stickle/SlidingW")
OUTDIR <- "/gpfs01/home/mbxlm9/Stickle/plots"

#loading in sliding window pc1 scores
sliding <- read.table("slidingpc1.txt", header = TRUE, sep ="\t")

#correcting my missspelling 
names(sliding)[4] <- "Individual"

#converting window start from bases to Mb
sliding$Position <- sliding$Start / 1000000

#standardising pc1 within each window
#allows for better direct comparison across chrom
sliding <- sliding %>%
	group_by(Window) %>%
	mutate(PC1_scaled = as.numeric(scale(PC1))) %>%
	ungroup()

#keeping only wanted region
sliding_zoom <- sliding %>%
	filter( Position >= 26.15, Position <= 26.30)

#keeps individuals in order
sliding_zoom$Individual <- factor(sliding_zoom$Individual,
         levels = unique(sliding_zoom$Individual))

#gene coordinations from gff annotation
genes <- data.frame( Gene = c("ENSGACG00000014345", "atp1a1a.2", "obsl1a", "ENSGACG00000014321", "CTDSP1"),
	Start = c( 26180323, 26233511, 26279422, 26288223, 26292833),
	End = c( 26203145, 26263851, 26285928, 26289109, 26297564)) 

#converting gene position to Mb 
genes$StartMb <- genes$Start / 1000000
genes$EndMb <- genes$End / 1000000

#creating heatmap
heatmap_zoom <- ggplot(sliding_zoom,
        aes( x = Position, y = Individual, fill = PC1_scaled) ) +
        geom_tile() + 
	geom_vline( data = genes, aes( xintercept = StartMb), linetype = "dashed", linewidth = 0.5) +
        geom_vline( data = genes, aes( xintercept = EndMb), linetype = "dashed", linewidth = 0.5) +
	scale_fill_gradient2(
        low = "blue",
        mid = "white",
        high = "red",
        midpoint = 0 ) +
	scale_x_continuous( limits = c(26.15, 26.30), expand = c(0,0)) +
        labs ( title = "Standardised Sliding PCA across chromosome I:26.15 - 26.30Mb",
                x = "Chromosome I position (Mb)",
                y = "Individual",
                fill = "Standardised PC1") +
        theme_minimal() +
        theme ( panel.grid = element_blank(),
                axis.text.y = element_blank(),
                axis.ticks.y = element_blank() )
#saving
ggsave(
      filename = file.path(OUTDIR,"genelabeled.png"),
        plot = heatmap_zoom,
        width = 10,
        height = 20,
        dpi = 300 )

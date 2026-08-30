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
library(patchwork)

#setting directories
setwd("/gpfs01/home/mbxlm9/Stickle/SlidingW")
OUTDIR <- "/gpfs01/home/mbxlm9/Stickle/plots"

#loading in polarised sliding window pc1 scores
sliding <- read.table("slidingpc1_polarised.txt", header = TRUE, sep ="\t", stringsAsFactors = FALSE)

#correcting my missspelling 
names(sliding)[4] <- "Individual"

#loading whole region pca scores
#used to order individuals in  heatmap
whole_pca <- read.table("/gpfs01/home/mbxlm9/Stickle/plots/basic_PCA_scores.txt", header = TRUE, sep ="\t", tringsAsFactors = FALSE)


#adding whole region pc1 to sliding 
sliding <- sliding %>%
        inner_join (whole_pca %>%
                        select (Individual, PC1), by = "Individual")


#converting window start from bases to Mb
sliding$Position <- sliding$Start / 1000000

#ordering individuals by whole region pc1
individual_order <- sliding %>%
        distinct(Individual, PC1) %>%
        arrange(PC1)
#applying order
sliding$Individual <- factor(sliding$Individual, levels = individual_order$Individual)

#keeping focal region
sliding_zoom <- sliding %>%
        filter( Position >= 26150000, Position <= 26300000)


#gene coordinations from gff annotation
genes <- data.frame( Gene = c("ENSGACG00000014345", "atp1a1a.2", "obsl1a", "ENSGACG00000014321", "CTDSP1"),
	Start = c( 26180323, 26233511, 26279422, 26288223, 26292833),
	End = c( 26203145, 26263851, 26285928, 26289109, 26297564)) 

#converting gene position to Mb 
genes$StartMb <- genes$Start / 1000000
genes$EndMb <- genes$End / 1000000

#setting gene order
genes$Gene <- factor(genes$Gene, levels=rev(genes$Gene))

#setting focal interval
low_start <- 26.190
low_end <- 26.245 

#creating gene lables at top
gene_track <- ggplot(genes, aes( y= Gene)) +
        # highlightin focal interval
        annotate("rect", xmin = low_start, xmax = low_end, ymin = -Inf, ymax = Inf, fill = "grey80", alpha = 0.6)+
        #adding genes
        geom_segment(aes (x= StartMb, xend = EndMb, yend = Gene), linewidth=6, colour = "grey35". lineend = "butt") +
        #marking boundaries
        geom_vline(xintercept = c(low_start, low_end), colour = "black", linewidth =0.8)+
        scale_x_continuous(limits =c(26.15, 26.30), breaks = seq(26.15, 26.30, 0.05), expand = c(0,0)) +
        labs( x = NULL, y = NULL) +
        theme_minimal (base_size = 14) +
        theme ( axis.text.x = element_blank(),
                axis.ticks.x = element_blank(),
                axis.text.y = element_text( size = 10, colour = "black"),
                axis.ticks.y = element_blank(),
                panel.grid = element_blank())


#creating heatmap
heatmap_zoom <- ggplot(sliding_zoom,
        aes( x = Position, y = Individual, fill = PC1_standardised) ) +
        geom_tile() + 
 # highlightin focal interval
        annotate("rect", xmin = low_start, xmax = low_end, ymin = -Inf, ymax = Inf, fill = "grey80", alpha = 0.6)+
#marking boundaries
        geom_vline(xintercept = c(low_start, low_end), colour = "black", linewidth =0.8)+
	scale_fill_gradient2(
        low = "blue",
        mid = "white",
        high = "red",
        midpoint = 0 ) +
	scale_x_continuous( limits = c(26.15, 26.30), breaks = seq(26.15, 26.30, 0.05), expand = c(0,0)) +
        labs (x = "Chromosome I position (Mb)", y = "Individual", fill = "Standardised PC1") +
        theme_minimal(base_size = 14) +
        theme ( axis.text.x = element_text(size = 11),
                axis.text.y = element_blank(),
                axis.ticks.y = element_blank(),
                panel.grid = element_blank(),
                axis.title = element_text(size = 11))


#cobining both 

final_plot <- gene_track / heatmap_zoom +
        plot_layout (heights = c(1.3, 8)) +
        plot_annotation( title = paste0("Standardised Sliding PCA Across the ChrI Candidate Region, 26.15 - 26.30Mb, \n with Genes of Interest"),
                theme = theme( plot.title = element_text(hjust = 0.5, face = "bold", size = 14)))

#saving
ggsave(
      filename = file.path(OUTDIR,"genelabeled.png"),
        plot = heatmap_zoom,
        width = 10,
        height = 20,
        dpi = 600 )

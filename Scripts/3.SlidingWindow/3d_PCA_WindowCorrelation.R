# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#     Sliding PCA Correlations      #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #

#library packages
library(ggplot2)
library(dplyr)

#setting working directory
setwd("/gpfs01/home/mbxlm9/Stickle/SlidingW")

#loading in sliding window pc1 scores
sliding <- read.table("slidingpc1_polarised.txt", header = TRUE, sep ="\t")

#correcting my missspelling 
names(sliding)[4] <- "Individual"

#loading whole inversion pca scores
whole_pca <- read.table("/gpfs01/home/mbxlm9/Stickle/plots/basic_PCA_scores.txt",
	header = TRUE, sep = "\t")

#indentifying marine individuals
marine_ids <- unique(sliding$Individual[sliding$ecotype == "marine"])

#polarising whole region pc1, marine individuals in same direction
whole_sign <- sign(median( whole_pca$PC1 [whole_pca$Individual %in% marine_ids], na.rm = TRUE))

if(whole_sign == -1) {
	whole_pca$PC1 <- -whole_pca$PC1}

#matcing whole region pc1 to each individual
sliding$whole_PC1 <- whole_pca$PC1[
	match (sliding$Individual, whole_pca$Individual)]

#creating empty results table
cor_results <- data.frame()

#calulating correlation for each window
cor_results <- sliding %>%
				group_by (Window) %>%
				summarise( Start = first(Start), End = first(End),
							Correlation = cor(PC1_scaled, whole_PC1, use = "complete.obs"), .groups = "drop")

#converting start position to mb
cor_results$Position <- cor_results$Start / 1000000

#saving results
write.table( cor_results, "slidingpc1_correlation_polarised.txt", sep = "\t",
		quote = FALSE, row.names = FALSE)


#removing final window
cor_results <- cor_results %>%
				slice(-n())

#plotting absolute correlation across inversion
cor_plot <- ggplot( cor_results, aes(x = Position, y = Correlation)) +
	geom_line( colour = "firebrick1", linewidth = 0.9) +
	geom_point(colour = "firebrick1", size =2)+
	labs( x = "Chromosome I Position (Mb)", 
		y = "Correlation with Whole Region PC1") +
	theme_classic(base_size = 14) +
	theme( axis.title = element_text( size = 13),
		axis.text = element_text( size = 11))

#saving plot
ggsave("slidingpc1_corr.png", cor_plot, width = 8, height = 6, dpi = 600)

 


# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#     Sliding PCA Correlations      #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #

#library packages
library(ggplot2)

#setting working directory
setwd("/gpfs01/home/mbxlm9/Stickle/SlidingW")

#loading in sliding window pc1 scores
sliding <- read.table("slidingpc1.txt", header = TRUE, sep ="\t")

#correcting my missspelling 
names(sliding)[4] <- "Individual"

#loading whole inversion pca scores
whole_pca <- read.table("/gpfs01/home/mbxlm9/Stickle/plots/basic_PCA_scores.txt",
	header = TRUE, sep = "\t")

#matching whole inversion pc1 to each individual
sliding$whole_PC1 <- whole_pca$PC1[match(sliding$Individual, whole_pca$Individual)]

#creating empty results table
cor_results <- data.frame()

#calulating correlation for each window
for(i in 1:48) {
	#selecting one window	
	window <- sliding[sliding$Window == i,]
	#correlation between window pc1 and whole inv pc1
	pc_cor <- cor(window$PC1, window$whole_PC1)
	#saving results
	cor_results <- rbind( cor_results, data.frame(
			Window = i, Start = window$Start[1],
			End = window$End[1],
			Correlation = pc_cor, Absolute_Correlation = abs(pc_cor)))}

#converting start position to mb
cor_results$Position <- cor_results$Start / 1000000

#saving results
write.table( cor_results, "slidingpc1_correlation.txt", sep = "\t",
		quote = FALSE, row.names = FALSE)

#plotting absolute correlation across inversion
cor_plot <- ggplot( cor_results, aes(x = Position, y = Absolute_Correlation)) +
	geom_line() +
	geom_point()+
	labs( title = "Similarity of local PC1 across chromosome I inversion",
		x = "Chromosome I position (Mb)", 
		y = "Absolute correlation with whole-inversion PC1") +
	theme_minimal()

#saving plot
ggsave("slidingpc1_corr.png", cor_plot, width = 8, height = 6, dpi = 300)

 


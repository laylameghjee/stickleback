# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#        Sliding Window Plot        #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #


#library packages
library(vcfR)
library(adegenet)

#setting wd
setwd("/gpfs01/home/mbxlm9/Stickle/SlidingW")

#loading info
windows <- read.table("window_info.txt", header = TRUE, sep = "\t")

#creating empty results table
allpc1 <- data.frame()

#running pc1 for each window
for(i in 1:nrow(windows)) {
	#loading vcf
	vcf <- read.vcfR(windows$VCF[i], verbose = FALSE)
	#converting to genlight object
	gen<-vcfR2genlight(vcf)
	#running pca
	pca <- glPca(gen, nf = 1, center = TRUE, scale = FALSE, parallel = TRUE, n.cores = 8)

	#saving scores for the window 
	window_pc1 <- data.frame(
		Window = windows$Window[i],
		Start = windows$Start[i],
		End = windows$End[i],
		Individal = rownames(pca$scores),
		PC1 = pca$scores[,1])
	
	#adding window to reslts
	allpc1 <- rbind(allpc1, window_pc1)
	#removing before next window 
	rm(vcf, gen, pca, window_pc1)
	gc() }

#saving combined pc1 results
write.table(allpc1, "slidingpc1.txt", sep = "\t", quote = FALSE, row.names = FALSE)

	

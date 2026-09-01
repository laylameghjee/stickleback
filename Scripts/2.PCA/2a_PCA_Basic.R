# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#       Basic PC1 v PC2 Plot        #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #

#library packages 
library(vcfR)
library(adegenet)
library(ggplot2)

#setting directories 
INPUT <- "/gpfs01/home/mbxlm9/Stickle/vcf/inversion/core_inversion.snps.vcf.gz"
OUTDIR <- "/gpfs01/home/mbxlm9/Stickle/plots"

#loading vcf
VCF <- read.vcfR(INPUT)

#keeping biallelic snps
#multiallelic variants removed before pca
VCF2 <- VCF[is.biallelic(VCF),]

#converting snp data into genlight object
#each indv represented by their snp genotypes

GEN <- vcfR2genlight(VCF2)

#running pca
#nf=3 keeps first three PC
#center - centers genotype values before pca
#scale - snps not standardised to = variance 

pca <- glPca(GEN,nf = 3, center = TRUE, scale = FALSE, parallel = TRUE,n.cores = 8)

#extracting pca scores 
pca_scores <- as.data.frame(pca$scores)

#adding sample names
pca_scores$Individual <- row.names(pca_scores)

#saving 
write.table( pca_scores, file = file.path(OUTDIR,"basic_pca_scores.txt"),sep = "\t",row.names = FALSE)

#plotting
pca_plot <- ggplot(
	data = pca_scores,
	aes(
	x = PC1,
	y = PC2 ) ) +
	geom_point(
	size =2,
	alpha = 0.4,
	colour = "cadetblue2") +
	labs ( x = "PC1",
	y = "PC2" ) +
	theme_classic(base_size = 14) +
	theme( axis.title = element_text( size = 13),
		axis.text = element_text( size = 11))

#saving 
ggsave(
	filename = file.path(OUTDIR,"basic_pca.png"), 
	plot = pca_plot,
	width = 7,
	height = 6,
	dpi = 600 ) 



# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#      Neighbour Joining Tree       #
#      Author - Layla Meghjee       #
# # # # # # # # # # # # # # # # # # #

#library packages
library(vcfR)
library(adegenet)
library(ape)


#setting files and directories
vcf_file <- "/gpfs01/home/mbxlm9/Stickle/vcf/inversion/core_inversion.snps.vcf.gz"
outdir <- "/gpfs01/home/mbxlm9/Stickle/NJtree"

#reading vcf
vcf <- read.vcfR(vcf_file)

#keeping biallelic snps
vcf <- vcf[is.biallelic (vcf),]


#converting vcf to genlight object
genlight_ata <- vcfR2genlight(vcf)

#converting genotupes into numeric matrix
geno <- as.matrix(genlight_ata)

#saving number of loci
n_loci <- ncol (geno)


#adding names
rownames(geno) <- indNames (genlight_ata)


#calculating pairwise genetic distance
#manhattan distance 0 = same genotype, 1 = one allele difference, 2 = two allele differences

genetic_distance <- dist(geno, method = "manhattan")

#converting to mean allelic difference per locus
genetic_distance <- genetic_distance / (2* n_loci)

#saving genetic distance matrix
saveRDS(genetic_distance, file = file.path( outdir, "ChrI_genetic_distance.rds"))

#removing genotype matrix before tree construction 
rm(geno)

#building neighbout joining tree
nj_tree <- nj(genetic_distance)

#saving tree as rds and newick 
saveRDS(nj_tree, file = file.path( outdir, "ChrI_NJ_tree.rds"))
write.tree(nj_tree, file = file.path (outdir, "ChrI_NJ_tree.newick"))


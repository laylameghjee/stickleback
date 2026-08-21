#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=25g
#SBATCH --time=1:00:00
#SBATCH --job-name=trim_gff
#SBATCH --output=/gpfs01/home/mbxlm9/Stickle/Logs/out/slurm-%x-%j.out
#SBATCH --error=/gpfs01/home/mbxlm9/Stickle/Logs/err/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk


# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#          Trim GFF File            #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #

#importing and activating project conda env
source $HOME/.bash_profile
conda activate indproj

#setting directories
INDIR=/gpfs01/home/mbxlm9/Stickle/vcf/inversion
OUTDIR=/gpfs01/home/mbxlm9/Stickle/annotation

#setting input and output
VCF=${INDIR}/core_inversion.snps.vcf.gz
OUTVCF=${OUTDIR}/atp1a1a.snps.vcf.gz

#extracting atp1a1a gene region
bcftools view \
	-r chrI:26233511-26263851 \
	--threads 8 \
	-Oz \
	-o "$OUTVCF" \
	"$VCF"

#indexing output
bcftools index -f "$OUTVCF"

#counting snps 
bcftools  index -n "$OUTVCF"

#checking all samples ran 
bcftools query -l "$OUTVCF" | wc -l

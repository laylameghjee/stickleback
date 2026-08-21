#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32g
#SBATCH --time=1:00:00
#SBATCH --job-name=inversion
#SBATCH --output=/gpfs01/home/mbxlm9/Stickle/Logs/out/slurm-%x-%j.out
#SBATCH --error=/gpfs01/home/mbxlm9/Stickle/Logs/err/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk

# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#       Trimming To Inversion       #
#      Author - Layla Meghjee       #
# # # # # # # # # # # # # # # # # # #

#importing and activating project conda env
source $HOME/.bash_profile
conda activate indproj

#setting directories
INDIR=/gpfs01/home/mbxlm9/Stickle/vcf/trimmed
OUTDIR=/gpfs01/home/mbxlm9/Stickle/vcf/inversion

#making outdir if it doesnt exist already
mkdir -p "$OUTDIR"

#setting vcf files
VCF=${INDIR}/trimmed_chrI.snps.vcf.gz
OUTVCF=${OUTDIR}/core_inversion.snps.vcf.gz

#extractin inversion region
#inversion region is between 26 - 26.5 mbs

bcftools view \
  -r chrI:26000000-26500000 \
  --threads 16 \
  -Oz \
  -o "$OUTVCF" \
  "$VCF"

#indecing the new vcf
bcftools index \
  -f \
  "$OUTVCF"


#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=25g
#SBATCH --time=5:00:00
#SBATCH --job-name=snp_qc
#SBATCH --output=/gpfs01/home/mbxlm9/Stickle/Logs/out/slurm-%x-%j.out
#SBATCH --error=/gpfs01/home/mbxlm9/Stickle/Logs/err/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk

# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#              SNP QC               #
#      Author - Layla Meghjee       #
# # # # # # # # # # # # # # # # # # #

#importing and activating project conda env
source $HOME/.bash_profile
conda activate indproj

#setting directories
INDIR=/gpfs01/home/mbxlm9/Stickle/vcf/inversion
OUTDIR=/gpfs01/home/mbxlm9/Stickle/qc

#making outdir if it doesnt exist already
mkdir -p "$OUTDIR"

#setting input vcf file
VCF=${INDIR}/inversion.snps.vcf.gz 
PRE=${OUTDIR}/chrI_snps

#overall vcf stats
bcftools stats \
  "$VCF" \
  > "${PRE}.stats"


#missingness per snp
vcftools \
  --gzvcf "$VCF" \
  --missing-site \
  --out "${PRE}.miss"

#total depth per snp
vcftools \
  --gzvcf "$VCF" \
  --site-depth \
  --out "${PRE}.depth"


#mean depth per snp
vcftools \
  --gzvcf "$VCF" \
  --site-mean-depth \
  --out "${PRE}.meandepth"

#allele freq per snp
vcftools \
  --gzvcf "$VCF" \
  --freq \
  --out "${PRE}_allfreq"

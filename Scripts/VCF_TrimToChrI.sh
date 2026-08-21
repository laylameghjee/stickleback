#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=25g
#SBATCH --time=1:00:00
#SBATCH --job-name=TrimVCF
#SBATCH --output=/gpfs01/home/mbxlm9/Stickle/Logs/out/slurm-%x-%j.out
#SBATCH --error=/gpfs01/home/mbxlm9/Stickle/Logs/err/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk

# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#          Trim VCF to ChrI         #
#      Author - Layla Meghjee       #
# # # # # # # # # # # # # # # # # # #

#importing and activating project conda env
source $HOME/.bash_profile
conda activate indproj

#setting directories
INDIR=/gpfs01/home/mbxlm9/Stickle/vcf/raw
cd "$INDIR"

#setting contig name for selected chr
CHR=chrI

#setting input and output files
INPUT=${INDIR}/rawg0214_Gasterosteus_aculeatus_TobiasPatterson.vcf.gz
OUTPUT=${INDIR}/trimmed_${CHR}.snps.vcf.gz

#trimming the vcf file
bcftools view \
  --regions "$CHR" \
  --types snps \
  --output-type z \
  --output ${OUTPUT} \
  --threads 8 \
  "$INPUT"

#making index for output
bcftools index -f "$OUTPUT"

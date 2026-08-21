#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=4:00:00
#SBATCH --job-name=IndexVCF
#SBATCH --output=/gpfs01/home/mbxlm9/Stickle/Logs/out/slurm-%x-%j.out
#SBATCH --error=/gpfs01/home/mbxlm9/Stickle/Logs/err/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk

# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#            Indexing VCF           #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #


#importing and activating project conda env
source $HOME/.bash_profile
conda activate indproj

#setting directories
INDIR=/gpfs01/home/mbxlm9/Stickle/vcf/raw

#setting input
INPUT=${INDIR}/rawg0214_Gasterosteus_aculeatus_TobiasPatterson.vcf.gz

bcftools index -f "$INPUT"

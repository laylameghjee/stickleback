#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25g
#SBATCH --time=1:00:00
#SBATCH --job-name=make_pca_windows
#SBATCH --output=/gpfs01/home/mbxlm9/Stickle/Logs/out/slurm-%x-%j.out
#SBATCH --error=/gpfs01/home/mbxlm9/Stickle/Logs/err/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk


# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#   Make Windows for Sliding Plot   #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #

#importing and activating project conda env
source $HOME/.bash_profile
conda activate indproj

#setting files and directories
vcf="/gpfs01/home/mbxlm9/Stickle/vcf/inversion/core_inversion.snps.vcf.gz"
OUTDIR="/gpfs01/home/mbxlm9/Stickle/SlidingW"

#inversion  info
REGION_START=26000000
REGION_END=26500000
WINDOW_SIZE=25000
STEP_SIZE=10000
WINDOW_NUMBER=1

#creating overlappinf 25 kb windowa
#windows move in 10kb steps

for (( START=${REGION_START}; START+${WINDOW_SIZE}-1<=${REGION_END}; START+=${STEP_SIZE}))
do
	END=$((START + WINDOW_SIZE -1))
	windvcf="${OUTDIR}/chrI_${START}_${END}.vcf.gz"
	#extracting snps in window
	#-m2 keeps sites w exactly 2 alleles
	#-v snps keeps snps only
	bcftools view \
	-r chrI:${START}-${END} \
	-m2 \
	-M2 \
	-v snps \
	-Oz \
	-o ${windvcf} \
	${vcf}

	#indexing
	bcftools index -t \
	${windvcf}

	#counting snps in window
	snp_count=$(bcftools index -n ${windvcf})
	#cointin samp;es
	sample_count=$(bcftools query -l ${windvcf} | wc -l)

	WINDOW_NUMBER=$((WINDOW_NUMBER +1 ))

done


#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32g
#SBATCH --time=2:00:00
#SBATCH --job-name=RunR Script
#SBATCH --output=/gpfs01/home/mbxlm9/Stickle/Logs/out/slurm-%x-%j.out
#SBATCH --error=/gpfs01/home/mbxlm9/Stickle/Logs/err/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk

# # # # # # # # # # # # # # # # # # #
# Individual Research Project 25/26 #
#    Stickleback ChrI Inversion     #
#        2 Region PCA Plot          #
#      Author - Layla Meghjee 	    #
# # # # # # # # # # # # # # # # # # #

#runs r script through conda env
#replace XXX with script name/path
/gpfs01/home/mbxlm9/miniconda3/envs/indproj/bin/Rscript /gpfs01/home/mbxlm9/Stickle/Scripts/XXX

# Population Genetic Structure across ChrI Candidate Inversion Region in Stickleback #


## Project Overview 
This project investigates population genetic structure across a 500KB chromosome I (ChrI) candidate inversion region in 906 globally distributed *Gasterosteus aculeatus* (threespine stickleback) individuals. The study examines how freshwater-marine ecological divergence, broad geographic history and fine scale genomic architecture contribute to patterns of genetic variation within this region.  

Whole region principal component analysis (PCA) is used to characterise the dominant patterns of genetic differentiation to examine  their relationship with freshwater-marine ecotype and geographic population structure. Sliding window PCA is then used to determine how consistently whole region genetic structure is maintained across genomic position and to identify localised departures from the broader pattern. Ecological and geographic classifications are subsequently incorporated to investigate the distribution of this heterogeneity, while fine scale gene annotation is used to place the strongest local genomic departure within its genomic context.  


By integrating ecology, geography, and genomic position this project treats the ChrI candidate inversion region not simply as an ecological marker but as a structured genomic region in which population history, ecological divergence, and inversion associated genomic architecture interact to shape the observed genetic variation.  


## Research Aims

The overall aim of this study is to characterise population genetic structure across a 500 KB ChrI candidate region containing the candidate inversion in globaly distributed *G. aculeatus*. Specifically, this project aims to:  
  
1. Characterise freshwater-marine ecological differentiation across the ChrI candidate region and determine how this varies across geographic population backgrounds. 
2. Determine how consistently whole region structure is maintained across genomic position and whether localised departures occur.
3. Examine the geographic distribution and genomic content of variation within the candidate region.  

Together these objectives are designed to determine whether population structure across this region is best explained by a single ecological contrast or instead reflects the combined influence of geographic history, ecological divergence and genomic architecture.  
  

## Repository Structure 

The repository is organised into analysis scripts, example outputs, and the computational environment used for the project. Scripts are grouped according to the main stages of the analysis workflow.  

```
stickleback/  
|    
|- README.md  
|- indproj.yml  
|  
|- Example_Plots/  
|
|- Scripts/  
|        |- 1.DataPrep/  
|        |- 2.PCA/  
|        |- 3.SlidingWindow/  
|        |- 4.NeighbourJoining/  
|        |- 5.AdditionalAnalysis/  
|        |- runR.sh  

```

## Data 

## Data Source & Availability  
The genomic data analysed within this project were obtained from a preliminary dataset assembled as part of the RepAdapt Project. The dataset is identified as `rawg0214` and contains whole genome variant data and associated metadata from 906 globally distributed *G. aculeatus* populations.  
  
The RepAdapt dataset was preliminary at the time of this project and combines data contributed by multiple independent studies and research groups. Some of the studies contributing samples had not yet been published at the time of analysis.  
  
The complete genomic dataset is not redistributed through this repository because of both its large size and the inlusion of unpublished data. The repository instead contains the scripts, analysis workflow, and computational environment required to reproduce the analyses when authorised access to the original data is avaliable.  

More information on the RepAdapt Project [here](https://yeamanlab.weebly.com/repadapt.html)
  
### Genomic Data
The primary genomic input was a compressed VCF file containing whole genome variant calls for 906 *G. aculeatus* individuals. All genomic coordinates used throughout this project refer to the V5 *G. aculeatus* reference assembly. The genomic dataset was progressively reduced from the complete whole genome dataset to a ChrI subset, and then to the 500 KB candidate inversion region analysed within this project.  

| Analysis Stage   | File                                                   | Description               | Format        |Variant Records | File Size |
|------------------|--------------------------------------------------------|---------------------------|---------------|----------------|-----------|
|Whole genome input|`rawg0214_Gasterosteus_aculeatus_TobiasPatterson.vcf.gz`| Preliminary genome dataset| compressed VCF|108,406,458     | 278.11 GB |
|ChrI SNP subset |`trimmed_chrI.snps.vcf.gz` |SNPs retained after trimming to ChrI| compressed VCF| 7,054,553| 18.78 GB|
|Candidate Region SNP subset| `core_inversion.snps.vcf.gz`|SNPS within the ChrI 26.0-26.5 MB region|compressed VCF| 124,287| 335.73 MB |


### Metadata

The original sample metadata were supplied with the genomic data and was an Excel workbook, `rawg0214_Gasterosteus_aculeatus_metadata.xlsx` that was 264.45 KB in size. This metadata contained information describing sample identity, population assignment, geographical location, ecological classification, source study among others. Sample identifiers within the metadata were matched to individuals present within the genomic VCF so that ecological and geographic information could be incoorporated into downstream analyses.  

A processed metadata workbook containing the most used classifications in the analyses was generated as `inversion_meta.xlsx` and had a size of 53.20 KB. 

Ecological metadata were simplified into three catagories for downstream analysis. Lake and stream samples were grouped into freshwater, and any without a classification were put into unknown. 

|Ecotype| Number of Individuals|
|-------|----------------------|
|Freshwater| 438|
|Marine| 387|
|Unknown| 81|

  
Sampling longitude was used to assign individuals consistently to four broad geographic areas. 

|Geographic Area| Individuals|
|---------------|------------|
|East Atlantic| 344|
|West Atlantic| 168|
|East Pacific| 345|
|West Pacific| 49|


### Reference Genome & Genome Annotation
All genomic coordinates used in this project refer to the V5 *G. aculeatus* reference assembly. Gene annotation information was processed as compressed GFF files. 

|File| Description| Format| File Size|
|----|------------|-------|----------|
|`toannotate.gff.gz`| Broader V5 annotation file used for genomic annotation| compressed GFF| 4.66 MB|
|`section_annotate.gff.gz`| Subset used for fine scale focal interval| compressed GFF| 557 bytes| 

## Computational Environment & Dependencies 
All computational analyses were performed using scripted Bash and R workflows on the University of Nottingham's High Performance Computing (HPC) environment. Software and package dependencies were managed using a dedicated Conda environment named `indproj`. The complete environment specification used for this project can be found in `indproj.yml`. This file contains the packages and dependencies required by the analytical workflow and should be treated as the definitive record of the computational environment used for the project. 

### Environment Installation

To install the project environmnet follow these instructions:  

1. Firstly clone the repository and move into it
```bash
git clone https://github.com/laylameghjee/stickleback.git
cd stickleback
```  
  
2. Create the Conda environment from the supplied file  
```bash
conda env create -f indproj.yml
```  
  
3. Activate environment 
```bash
conda activate indproj
```  
  
To check the installation of particular packages and tools, and to also check their versions use
```bash
[pacakgename] --version
```  

## Analysis Workflow 

1. **Data Preparation**  
Whole genome VCF was indexed, restricted to ChrI and then subset to the 26.0 - 26.5 MB inversion candidate region.  
  
2. **Variant Quality Assessment**  
Sequencing depth, geontype quality, missingness, variant quality and allele frequency distributions were examined before downstream analysis.  
  
3. **Whole Region PCA**  
PCA was performed across the complete candidate region to characterise overall genetic structure and examine freshwater-marine and geographic differentiation.  
  
4. **Sliding Window PCA**  
The candidate Region was dicided into overlapping 25KB windows advancing in 10KB steps. PCA was performed independently within each window and PC1 scores were polarised to a common orientation.  
  
5. **Local Genomic Structure**  
Window specific PC1 scores were compared with whole region PC1 using Pearson correlation to identify localised departures from the broader genomic pattern. Ecological and geographic patterns within these departures were then examined.  
  
6. **Fine Scale Annotation**
Gene annotation was incorporated around the focal 26.2 MB interval to place the strongest local genomic change within its genomic context.  
  
7. **Neighbour-Joining Analysis**  
Pairwise genetic distances across the candidate region were used to generate an independent representation of relationships among the 906 individuals.  

## Outputs  
The workflow produces both analytical data files and graphical outputs used within the study. Example figures generated by the workflow are provided in `Example_Plots/`. Key intermediate and final data files include but are not limited too:  

|Output| Description |
|------|-------------|
|`basic_PCA_scores.txt`| Whole region PCA scores for all 906 individuals|
|`slidingpc1_polarised.txt`| Polarised and standardised PC1 scores across sliding windows|
|`ChrI_genetic_distance.rds`| Pairwise genetic distance object for neighbour-joining|

## Acknowledgements  

This project has been completed as part of the 2025/26 MSc Bioinformatics course at The University of Nottingham, with Andrew MacColl and Christophe Patterson as my supervisors. 



# Population Genetic Structure across ChrI Candidate Inversion Region in Stickleback #


## Project Overview 
This project investigates population genetic structure across a 500kb chromosome I (ChrI) candidate inversion region in 906 globally distributed *Gasterosteus aculeatus* (threespine stickleback) individuals. The study examines how freshwater-marine ecological divergence, broad geographic history and fine scale genomic architecture contribute to patterns of genetic variation within this region.  

Whole region principal component analysis (PCA) is used to characterise the dominant patterns of genetic differentiation to examine  their relationship with freshwater-marine ecotype and geographic population structure. Sliding window PCA is then used to determine how consistently whole region genetic structure is maintained across genomic position and to identify localised departures from the broader pattern. Ecological and geographic classifications are subsequently incorporated to investigate the distribution of this heterogeneity, while fine scale gene annotation is used to place the strongest local genomic departure within its genomic context.  


By integrating ecology, geography, and genomic position this project treats the ChrI candidate inversion region not simply as an ecological marker but as a structured genomic region in which population history, ecological divergence, and inversion associated genomic architecture interact to shape the observed genetic variation.  


## Research Aims

The overall aim of this study is to characterise population genetic structure across a 500 kb ChrI candidate region containing the candidate inversion in globaly distributed *G. aculeatus*. Specifically, this project aims to:  
  
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
||- Example_Plots/  
|
||- Scripts/  
|        |- 1.DataPrep/  
|        |- 2.PCA/  
|        |- 3.SlidingWindow/  
|        |- 4.NeighbourJoining/  
|        |- 5.AdditionalAnalysis/  
|        |- SNP_QC.sh  
|        |- runR.sh  

```

## Data 

## Data Source & Availability  
The genomic data analysed within this project were obtained from a preliminary dataset assembled as part of the RepAdapt Project. The dataset is identified as `rawg0214` and contains whole genome variant data and associated metadata from 906 globally distributed *G. aculeatus* populations.  
  
The RepAdapt dataset was preliminary at the time of this project and combines data contributed by multiple independent studies and research groups. Some of the studies contributing samples had not yet been published at the time of analysis.  
  
The complete genomic dataset is not redistributed through this repository because of both its large size and the inlusion of unpublished data. The repository instead contains the scripts, analysis workflow, and computational environment required to reproduce the analyses when authorised access to the original data is avaliable.  
  
### Genomic Data
The primary genomic input was a compressed VCF file containing whole genome variant calls for 906 *G. aculeatus* individuals. All genomic coordinates used throughout this project refer to the V5 *G. aculeatus* reference assembly. The genomic dataset was progressively reduced from the complete whole genome dataset to a ChrI subset, and then to the 500 kb candidate inversion region analysed within this project.  

| Analysis Stage   | File                                                   | Description               | Format        |Variant Records | File Size |
|------------------|--------------------------------------------------------|---------------------------|---------------|----------------|-----------|
|Whole genome input|`rawg0214_Gasterosteus_aculeatus_TobiasPatterson.vcf.gz`| Preliminary genome dataset| compressed VCF|108,406,458     | 278.11 GB |
|ChrI SNP subset |`trimmed_chrI.snps.vcf.gz` |SNPs retained after trimming to ChrI| compressed VCF| 7,054,553| 18.78 GB|
|Candidate Region SNP subset| `core_inversion.snps.vcf.gz`|SNPS within the ChrI 26.0-26.5 Mb region|compressed VCF| 124,287| 335.73 MB |


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
 


## Computational Environment 
### Software & Dependencies 
### Environment Installation


## Analysis Workflow 


## Script Reference 
## Key Analysis Parameters
## Outputs
## Reproducibility Notes
## Acknowledgements 




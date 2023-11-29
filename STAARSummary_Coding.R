##########################################################
# Summarization and visualization of gene-centric 
# coding analysis results
##########################################################
rm(list=ls())
gc()

## load required packages
library(gdsfmt)
library(SeqArray)
library(SeqVarTools)
library(STAAR)
library(STAARpipeline)
library(STAARpipelineSummary)

#####################################
#           User Input
#####################################
## aGDS directory
agds_dir <- get(load("./Preparation_for_Association_Model/agds_dir.Rdata"))

## Known loci
known_loci <- get(load("./Output_Association/Lung_Cancer/Known_Loci_Pruned/Freeze_1_LuC_known_loci_individual_analysis_genome_LD_pruning.Rdata"))
# known_loci <- NULL

## Null model
obj_nullmodel <- get(load("./Preparation_for_Association_Model/Null_Model_archive/obj_nullmodel_LuC.Rdata"))

## results path
input_path <- "./Output_Association/Lung_Cancer/Gene_Centric_Coding/"
output_path <- input_path
## number of jobs
gene_centric_coding_jobs_num <- 381
## results name
gene_centric_results_name <- "Freeze_1_LuC_Coding"

## QC_label
QC_label <- "annotation/filter"
## geno_missing_imputation
geno_missing_imputation <- "mean"
## variant_type
variant_type <- "SNV"
## method_cond
method_cond <- "optimal"
## alpha level
alpha <- 5E-07

## Annotation_dir
Annotation_dir <- "annotation/info/FunctionalAnnotation"
## Annotation channel
Annotation_name_catalog <- get(load("./Preparation_for_Association_Model/Annotation_name_catalog.Rdata"))
# Or equivalently
# Annotation_name_catalog <- read.csv("/path_to_the_file/Annotation_name_catalog.csv")
## Use_annotation_weights
Use_annotation_weights <- TRUE
## Annotation name
Annotation_name <- c("CADD","LINSIGHT","FATHMM.XF","aPC.EpigeneticActive","aPC.EpigeneticRepressed","aPC.EpigeneticTranscription",
                     "aPC.Conservation","aPC.LocalDiversity","aPC.Mappability","aPC.TF","aPC.Protein")

###########################################################
#           Main Function 
###########################################################
Gene_Centric_Coding_Results_Summary(agds_dir=agds_dir,gene_centric_coding_jobs_num=gene_centric_coding_jobs_num,
                                    input_path=input_path,output_path=output_path,gene_centric_results_name=gene_centric_results_name,
                                    obj_nullmodel=obj_nullmodel,known_loci=known_loci,
                                    method_cond=method_cond,
                                    QC_label=QC_label,geno_missing_imputation=geno_missing_imputation,variant_type=variant_type,
                                    Annotation_dir=Annotation_dir,Annotation_name_catalog=Annotation_name_catalog,
                                    Use_annotation_weights=Use_annotation_weights,Annotation_name=Annotation_name,
                                    alpha=alpha,manhattan_plot=TRUE,QQ_plot=TRUE)
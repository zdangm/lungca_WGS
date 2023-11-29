#############################
# Dynamic window analysis 
#############################
rm(list=ls())
gc()

## load required packages
library(gdsfmt)
library(SeqArray)
library(SeqVarTools)
library(STAAR)
library(SCANG)
library(STAARpipeline)

#############################
#        User Input
#############################
## Number of jobs for each chromosome
jobs_num <- get(load("./Preparation_for_Association_Model/jobs_num.Rdata"))
## aGDS directory
agds_dir <- get(load("./Preparation_for_Association_Model/agds_dir.Rdata"))
## Null model
obj_nullmodel_SCANG_STAAR <- get(load("./Preparation_for_Association_Model/Null_Model_archive/obj_nullmodel_SCANG_LuC.Rdata"))

## QC_label
QC_label <- "annotation/filter"
## variant_type
variant_type <- "SNV"
## geno_missing_imputation
geno_missing_imputation <- "mean"

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

## output path
output_path <- "./Output_Association/Lung_Cancer/Dynamic_Window/"
## output file name
output_file_name <- "Freeze_1_LuC_Dynamic_Window"
## input array id from batch file (Harvard FAS RC cluster)
arrayid <- as.numeric(commandArgs(TRUE)[1])

###########################################################
#           Main Function 
###########################################################
## Number of jobs for SCANG
sum(jobs_num$scang_num)

chr <- which.max(arrayid <= cumsum(jobs_num$scang_num))
group.num <- jobs_num$scang_num[chr]

if (chr == 1){
  groupid <- arrayid
}else{
  groupid <- arrayid - cumsum(jobs_num$scang_num)[chr-1]
}

## aGDS file
agds.path <- agds_dir[chr]
genofile <- seqOpen(agds.path)

start_loc <- (groupid-1)*1.5e6 + jobs_num$start_loc[chr]
end_loc <- min(start_loc + 1.5e6 - 1, jobs_num$end_loc[chr])

results_scang <- Dynamic_Window_SCANG(chr=chr,start_loc=start_loc,end_loc=end_loc,genofile=genofile,obj_nullmodel=obj_nullmodel_SCANG_STAAR,
                                      QC_label=QC_label,variant_type=variant_type,geno_missing_imputation=geno_missing_imputation,
                                      Annotation_dir=Annotation_dir,Annotation_name_catalog=Annotation_name_catalog,
                                      Use_annotation_weights=Use_annotation_weights,Annotation_name=Annotation_name)

save(results_scang,file=paste0(output_path,output_file_name,"_",arrayid,".Rdata"))

seqClose(genofile)
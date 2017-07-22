/*
##
## Script for analysing the mutations of a cohort of exome-sequenced samples downloaded from http://firebrowse.org/
##

####################
# LOAD DATA
####################
*/

#+ setup, include=FALSE
library(knitr)
opts_chunk$set( fig.align='center',
                message=FALSE,
                warnings=FALSE, 
                results='asis',
                echo=TRUE,
		cache=FALSE)

#'# Introduction

#' This practical consists of two parts: First, it will walk you through how to summarize and visualize mutations in cohort for a subset of genes. Second, it will show you how to calculate the weights for pre-defined mutational signatures in your samples. We will perform all the analysis in R using the ComplexHeatmap and the deconstructSigs packages.


#' We will work with the Breast Invasive Carcinoma (BRCA) SNV data set downloaded from [Firebrowse](http://firebrowse.org). There is one MAF-file (as specified on the [TCGA wiki-page](https://wiki.nci.nih.gov/display/TCGA/Mutation+Annotation+Format+%28MAF%29+Specification) containing the predicted SNVs for each sample. 

#'# Loading the data into R

#' First we need to load and merge the different files into a data frame in R. The list.files function can retrieve all filenames in a directory that contain a specific pattern. In our case all filenames should end with maf.txt. Since it is handy to get the full file name (including the directory name) we set full.names=TRUE. 

#+ listMAFfiles
# list all maf files in the download directory
dirname <- "gdac.broadinstitute.org_BRCA.Mutation_Packager_Calls.Level_3.2016012800.0.0/"
files <- list.files(dirname, pattern="*.maf.txt$", full.names=TRUE)
# inspect
#head(files)
#length(files)

#' There are 
{{length(files)}}
#' MAF files. The ldply-function in the plyr package is very useful if one would like to load and concatenate several files. The function will load each file into a data.frame and then merge the data.frame based on the column names.

#+ loadMAFfiles
# load one file after the other and concatinate to a large data frame
# NOTE: all input files should have the same structure
library(plyr)
data <- ldply(files, read.delim)
# inspect
#dim(data)
#head(data)
#sort(table(data$Tumor_Sample_Barcode))
#table(data$Variant_Type)

#' The resulting data.frame has
{{nrow(data)}}
#' mutations/rows. Note, that these are a mix of SNVs and small insertions and deletions. We can see that the number of mutations range from 
{{min(table(data$Tumor_Sample_Barcode))}}
#' to
{{max(table(data$Tumor_Sample_Barcode))}}
#' mutations per sample. With a median of 
{{median(table(data$Tumor_Sample_Barcode))}}
#' mutations per sample, a sample having 
{{max(table(data$Tumor_Sample_Barcode))}}
#' seems suspicious. At this point, we might want to inspect carefully those outliers and, if necessary, filters sample where we have reason to suspect quality or other issues that would make the sample incomparable to the rest of the cohort.

/*
####################
# PLOT A GENE X PATIENT MUTATION HEATMAP
####################
*/

#'# Plotting a gene x patient mutation heatmap

#' Now that we have settled on and loaded a cohort that we wish to analyse, we will look for frequently mutated genes among the cohort and inspect the distribution of mutations in these genes across the patients. We will use the function oncoPrint in the ComplexHeatmap package to do so. 

#'## Selection the top mutated genes

#' But first we need to define which genes to plot. You can imagine any kind of small gene list that you might be interested in. We will select the top-10 most frequently mutated genes:

#+ selectTopGenes
# make sure we have each mutated gene listed only once per sample
unique_genes_bysample <- sapply(split(data$Hugo_Symbol, data$Tumor_Sample_Barcode), unique)
# for each gene, calculate the number of samples with a mutation in the gene 
nrsamples_bygene <- table(unlist(unique_genes_bysample))
# select the top 10 most mutated genes
top10genes <- names(tail(sort(nrsamples_bygene), n=10))
top10genes

#' We see some well known cancer genes being among the top mutated genes. 

#'## Preparing the input for oncoPrint

#' We will now create a gene by patient matrix whose entries will indicate whether a certain gene is mutated ("MUT" entry) in a sample or not ("" as entry). As explained in their [vignette, oncoPrint](https://www.bioconductor.org/packages/devel/bioc/vignettes/ComplexHeatmap/inst/doc/s8.oncoprint.html) can visualize more than one type of alteration for each gene. For simplicity, we will plot a heatmap that contains only one type of mutation. Further, there are two options to represent the input for oncoPrint - have a look into the vignette and see which one is more intuitive for you.

#+ oncoPrintMat
# get the sample names
samplenames <- unique(data$Tumor_Sample_Barcode)
# initialize a gene by sample matrix
mat <- matrix("", ncol=length(samplenames), nrow=length(top10genes), dimnames=list(top10genes, samplenames))
# go through all genes and change the entry to "MUT" if a gene is mutated in a particular sample
for(gene in top10genes){
	# get the samples that have a mutation in the gene
	mutated_samples <- as.character(data[data[,1]%in%gene, "Tumor_Sample_Barcode"])
	# set the entries in the matrix to "MUT"
	mat[gene, mutated_samples] <- "MUT"
}
# inspect
# head(mat)

#' Next, we will need to make a mapping from the possible entries in the matrix to a function that gives the geometric representation of the mutation type. The non-mutated entries (indicated as "") will be called "background" in the list, otherwise the names in the list correspond to the mutation type names used in the matrix above (in our case only "MUT"). Here is an example:  

#+ styleMap
# define a style map for each type of mutation
alter_fun <- list( background = function(x, y, w, h) { grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill="lightgrey", col = NA)) },
		MUT = function(x, y, w, h) { grid.rect(x, y, w-unit(0.5, "mm"), h*0.33, gp = gpar(fill="red", col = NA)) })

#' In the example both, mutations and backgrounds will be drawn as rectangles. We will see that mutations will have rectangle that is only a third of the height of the background rectangle (indicated by h*0.33) and will be red while the background will be lightgrey.

#'## Plot the gene by patient mutation heatmap

#' Now we are almost ready to plot the heatmap, we just need to fill in the parameters as described below: 

#+ plotHeatmap
library(ComplexHeatmap)
oncoPrint(mat, 
	get_type = function(x) x, # how to get the different types of mutations for each entry in the matrix; in our case there are just two types "" and "MUT"
    	alter_fun = alter_fun, # to represent each mutation type in the plot; a mapping from mutation name to a function
	col=c("MUT"="red"), # legend color of the mutation types; should match what is given in alter_fun
	column_title = "BRCA firebrowse data set", # a title
	heatmap_legend_param = list(title = "", at = c("MUT"), labels = c("Mutation"))) # some labels for the legend

#' The heatmap shows a small rectangle if the gene (row) is mutated in the sample (column). Above the heatmap we see how many of the genes are mutated in each sample (this will be split by mutation type in case you have more than one mutation type). To the left of the heatmap we see the percent of sample that have a mutation in the gene. The barplot on the right shows the total number of samples that have a mutation in a particular gene (which will also be split into different mutation types if you have more than one). 

#'## Exercises

#' * Go to the firebrowse website and look at the results of MutSig2CV under the results, significantly mutated gene section. Which of the frequently mutated genes are not among the significantly mutated genes detected by MutSig2CV? Look at the gene in the UCSC genome browser and make use of the additional data that is available there, can you speculate why mutations in these genes are not significant?
#' * In the heatmap change the color and the size of the rectangle indicating the mutated genes. Can you represent the mutated gene as a circle (see vignette)?
#' * Bonus - try to adjust the code to visualize SNVs, deletions or insertions (as indicated by the Variant_Type column) by different colors.
#'

/*
####################
# CALCULATE WEIGHTS OF COSMIC MUTATIONAL SIGNATURES
####################
*/


#'# Calculate the weight of mutational processes

#' In the second part of this practical we will estimate the weights of the mutational signatures in each of our sample. We will use the [COSMIC mutational signatures](http://cancer.sanger.ac.uk/cosmic/signatures) as a basis. According to the website, the mutational signatures were learned from 10,952 exomes and 1,048 whole-genomes across 40 distinct types of human cancer from various sources. The goal of the following is to estimate which of these mutational processes were active in each of the BRCA samples. We will use the package deconstructSigs for this.

#'## Preparing the input for deconstructSigs

#' For each mutation we need its tri-nucleotide context. The function mut.to.sigs.input calculates this context from the hg19 genome assembly by default. All we have to do is to make sure that we use the same chromosome names as in the genome assembly and then to hand over the data containing the sample names, chromosome, start and end position, as well as reference and alternative allele for each mutation

#+ checkChromNames
# check if the chromosome names match what deconstructSigs expects 
unique(data[,"Chromosome"])
# add "chr" to each chromosome name
data[,"Chromosome"] <- paste0("chr", data[,"Chromosome"])
# filter mutations on some chromosome (e.g. chrM or "random"-chromosomes)
data <- data[!grepl("GL|chrMT", data[,"Chromosome"]), ]

#+ getTriNucs
# get the trinucleotide context of the mutations
library(deconstructSigs)
trinucs <- mut.to.sigs.input( data, 
				sample.id="Tumor_Sample_Barcode", # names of the corresponding columns in data
				chr="Chromosome", 
				pos="Start_Position", 
				ref="Reference_Allele", 
				alt="Tumor_Seq_Allele2")

#' At this point the function noticed that some of the samples have low numbers of mutations. Since we need a reliable estimate of the frequencies of mutations in their trinucleotide context, we might want to filter samples that have only few mutations. 

#+ filterSample
# filter samples with few mutations
trinucs_selected <- trinucs[rowSums(trinucs)>100,]

#'## Run weight estimation

#' DeconstructSigs runs on a per-sample basis, hence we have to call whichSignatures on each sample separately with the input as indicated below. 

#+ runDeconSigs
# initialize a list of the length of samples 
results <- vector("list", nrow(trinucs_selected))
names(results) <- row.names(trinucs_selected)
# run the estimation of exposures for each sample and save the results in the list
for( sID in row.names(trinucs_selected) ){
	results[[sID]] <- whichSignatures(trinucs_selected, # the matrix generated with mut.to.sigs.input 
						sample.id=sID, # the current sample ID
						signatures.ref=signatures.cosmic, # the data.frame with the signatures that comes with deconstructSigs
						tri.counts.method="exome2genome", # which normalization method to use
						contexts.needed=TRUE) # set to TRUE if your input matrix contains counts instead of frequencies
}

#' The output for each sample contains:
#' * the estimated weights per signature (weights),
#' * the input (tumor),
#' * the fitted values (product) using the weights and the signatures (how much can be explained by the weights),
#' * the difference between the fit and the observed frequencies (diff), and
#' * the weight that cannot be explained by any of the signatures.


#' We can plot these entries for each sample:

#+ plotSig
plotSignatures(results[[1]])
makePie(results[[1]])

#'## Plot the cohort

#' If we want to compare the contribution of a mutational process across the samples of a cohort, it is common to represent this as a barplot where each bar is colored by the contribution of each mutational process to the observed mutational profile of a sample. First, we concatenate the weights per sample into a sample by signature matrix:

#+ makeSigMat
# convert the exposures for each sample into a sample x signatures matrix
expo <- do.call("rbind", sapply(results, "[", 1))
# add the unknown value to the matrix such that the contributions add up to 1 per sample
Signature.unknown <- unlist(sapply(results, "[", 5))
expo <- cbind(expo, Signature.unknown)

#+ plotCohortSigs, fig.width=15
# reorder samples by similarity in their signature profiles
o <- row.names(expo)[hclust(dist(expo))$order]
# trick base graphics into putting the legend outside of the plot
par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
barplot(t(as.matrix(expo))[,o], las=2, col=rainbow(31))
legend("topright", inset=c(-0.1,0), legend=1:31, fill=rainbow(31), title="Signature", ncol=2)

/*
# find out the highest contributer per sample and see which signature affects most samples
table(colnames(expo)[apply(expo, 1, which.max)])

#' We will use ggplot to generate 
#+ reshape
# prepare data for plotting the contribution of each signature
library(ggplot2)
library(reshape)
toplot <- melt(as.matrix(expo))
names(toplot) <- c("sample", "signature", "weight")

# order samples by similarity
toplot$sample <- factor(toplot$sample, levels=row.names(expo)[hclust(dist(expo))$order])
 
# plot
ggplot(data=toplot, aes(x=sample, y=weight, fill=signature)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
*/

#'## Exercises

#' * Find the most common signatures among the sample. Use the signature with highest weight per sample and calculate the frequency of each signature across the cohort. Look up the top signatures on the COSMIC website. Do they make sense for BRCA data set?

  

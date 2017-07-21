#!/bin/bash

cd /home/participant/Course_Materials/Day3
mkdir tmp

# generate annular input from vcf file
../software/annovar/convert2annovar.pl \
	-format vcf4old  \
	HCC1143_vs_HCC1143_BL.annot.muts.vcf.gz \
	> tmp/HCC1143_vs_HCC1143_BL.annot.muts.avinput;

# perform gene-based annotation, by default against RefGene database
../software/annovar/annotate_variation.pl \
	--buildver hg19 \
  --outfile tmp/HCC1143_vs_HCC1143_BL.annot.muts.avinput \
	tmp/HCC1143_vs_HCC1143_BL.annot.muts.avinput \
	../software/annovar/humandb/;

# Exercises:
# Load the variant_function file into R and check how many variants/what percentage of variants fall in the different variant categories
# Load the exonic_variant_function and check 
#	- how many exonic variants are there?
#	- in which categories do the variants fall?
#	- find which variants affect your favourite gene (e.g. TP53)?
#	- bonus: what is the top-5 most mutated gene?

# perform region-based annotation
# choose one of the following cytoband wgRna phastConsElements46way tfbsConsSites gwasCatalog dgvMerged genomicSuperDups
db=tfbsConsSites;
../software/annovar/annotate_variation.pl \
	--regionanno \
	--build hg19 \
  --dbtype ${db} \
	tmp/HCC1143_vs_HCC1143_BL.annot.muts.avinput \
	../software/annovar/humandb/; 

# perform filter-based annotation
# choose one of the following snp138 exac03 esp6500si_all cg69 clinvar_20160302 cosmic70 icgc21 1000g2015aug nci60
db=snp138;
../software/annovar/annotate_variation.pl \
	--filter \
	--buildver hg19 \
	--dbtype ${db} \
	tmp/HCC1143_vs_HCC1143_BL.annot.muts.avinput \
	../software/annovar/humandb/;

# for convenience, annuvar can do all annotations together and produce a summary table containing all information
../software/annovar/table_annovar.pl \
	tmp/HCC1143_vs_HCC1143_BL.annot.muts.avinput \
	../software/annovar/humandb/ -buildver hg19 \
	--out HCC1143_vs_HCC1143_BL.flagged.muts.annovar \
	--remove \
	--protocol refGene,cytoBand,gwasCatalog,genomicSuperDups,dgvMerged,snp129,esp6500si_all,cosmic70,nci60,ljb23_sift \
	--operation g,r,r,r,r,f,f,f,f,f \
	--nastring NA \
	--csvout;


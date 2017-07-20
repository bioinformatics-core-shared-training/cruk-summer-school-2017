cd /reference_data/

wget http://www.broadinstitute.org/ftp/pub/seq/references/Homo_sapiens_assembly19.fasta
wget http://www.broadinstitute.org/ftp/pub/seq/references/Homo_sapiens_assembly19.fasta.fai
wget http://www.broadinstitute.org/ftp/pub/seq/references/Homo_sapiens_assembly19.dict

## Get reference data required for caveman
wget ftp://ftp.sanger.ac.uk/pub/cancer/dockstore/human/core_ref_GRCh37d5.tar.gz
wget ftp://ftp.sanger.ac.uk/pub/cancer/dockstore/human/SNV_INDEL_ref_GRCh37d5.tar.gz

## Get other references needed for wgs pipeline
wget ftp://ftp.sanger.ac.uk/pub/cancer/dockstore/human/VAGrENT_ref_GRCh37d5_ensembl_75.tar.gz
wget ftp://ftp.sanger.ac.uk/pub/cancer/dockstore/human/CNV_SV_ref_GRCh37d5.tar.gz
wget ftp://ftp.sanger.ac.uk/pub/cancer/dockstore/human/cytoband_GRCh37d5.txt
wget ftp://ftp.sanger.ac.uk/pub/cancer/dockstore/human/SUBCL_ref_GRCh37d5.tar.gz


## unzip the references required for caveman

tar zxf core_ref_GRCh37d5.tar.gz 
tar zxf SNV_INDEL_ref_GRCh37d5.tar.gz 

find . -type f | xargs chmod ugo+r
find . -type d | xargs chmod ugo+rx

cd ~
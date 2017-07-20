source("http://www.bioconductor.org/biocLite.R")
  options(BioC_mirror = c("Cambridge" = "http://mirrors.ebi.ac.uk/bioconductor/"))
options(repos = c("CRAN" = "http://cran.ma.imperial.ac.uk"))
biocLite(c("Biostrings", "ShortRead","biomaRt", "BSgenome","QDNAseq","exomeCopy",
        "rtracklayer", "ggbio", "Gviz","RColorBrewer","org.Hs.eg.db",
        "TxDb.Hsapiens.UCSC.hg19.knownGene","BSgenome.Hsapiens.UCSC.hg19",
        "wakefield","VariantAnnotation","limma","dplyr","ggplot2","tidyr","readr",
        "GenVisR","circlize","RColorBrewer","circlize", "InteractionSet","mclust","devtools","SomaticSignatures","deconstructSigs","COSMIC.76",
        "ComplexHeatmaps","plyr","reshape"))
        
library(devtools)
install_github("Crick-CancerGenomics/ascat/ASCAT")



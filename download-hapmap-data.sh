
cd /data/hapmap

wget ftp://ftp.ncbi.nlm.nih.gov/1000genomes/ftp/phase3/data/NA12878/alignment/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.bam -O NA12878.chr20.bam
samtools index NA12878.chr20.bam

wget ftp://ftp.ncbi.nlm.nih.gov/1000genomes/ftp/phase3/data/NA12874/alignment/NA12874.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.bam -O NA12874.chr20.bam
samtools index NA12874.chr20.bam


wget ftp://ftp.ncbi.nlm.nih.gov/1000genomes/ftp/phase3/data/NA12873/alignment/NA12873.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.bam -O NA12873.chr20.bam
samtools index NA12873.chr20.bam

cd ~ 
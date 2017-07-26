---
title: "Exercise: Assessing and Evaluating SNV Calls (Notes)"
author: "Matt Eldridge"
date: "July 2017"
output: html_document
---

<div style="line-height: 100%;"><br></div>

1. **chr8:142486034 C>T**
    * [IGV](http://localhost:60151/goto?locus=8:142486034)
        * _Turn off shading by base quality and zoom out to see mismatches in reads within surrounding region; many are sequencing errors with the mismatches having low base quality scores_
    * Nothing to suggest this mutation isn't real
    * Note that the allele fraction is 12% possibly reflective of the cellularity of the tumour sample and the copy number at this locus
    * ASCAT computes copy number of 8 in tumour in this region
    * CaVEMan determines that the most probable genotype in the tumour is CCCCCCCT
    * Synonymous variant so encoded amino acid is unchanged
    * <span style="color: #29a329">*TRUE*</span>

<div style="line-height: 20%;"><br></div>

2. **chr19:14860710 C>T**
    * [IGV](http://localhost:60151/goto?locus=19:14860710)
        * _Zoom out to view zero mapping quality reads in vicinity_
        * _Sort by mapping quality at the variant position_
        * _Load repeat annotations by clicking on `Load from Server...` from the `File` menu and selecting `Repeat Masker` annotations within `Variation and Repeats` section_
    * Filtered by cgpCaVEManPostProcessor
    * MQ filter (mean mapping quality < 21)
    * Reads with zero mapping quality in vicinity which could map equally well to another place in the genome
    * Variant reads have multiple mismatches
    * Variant within LINE repeat element
    * <span style="color: #e60000">*FALSE*</span>

<div style="line-height: 20%;"><br></div>

3. **chr8:50114475 T>G**
    * [IGV](http://localhost:60151/goto?locus=8:50114475)
        * _Centre on variant position and sort by base so that variant bases appear at the top of each track --- hover over each and look at the base quality score in the tooltip_
    * Low base qualities for variant G base at T position surrounded by run of several G bases (possible sequencing error)
    * Similar problem exists in the normal but it appears that CaVEMan is applying a base quality cut-off of 10 and variant bases with Q > 10 only exist in tumour
    * <span style="color: #e60000">*FALSE*</span>

<div style="line-height: 20%;"><br></div>

4. **chr3:45153669 C>A**
    * [IGV](http://localhost:60151/goto?locus=3:45153669)
        * _Set `Coverage allele fraction threshold` to 0.04 in alignment view preferences dialog (`View > Preferences > Alignments`)_
    * Low allele fraction
    * Just 4 out of 90 tumour reads support variant
    * Called by MuTect2 but not by CaVEMan
    * Missense variant in CDCP1 predicted to be damaging by SIFT and PolyPhen
    * <span style="color: #29a329">*TRUE*</span>

<div style="line-height: 20%;"><br></div>

5. **chr1:169147080 T>G**
    * [IGV](http://localhost:60151/goto?locus=1:169147080)
    * Misalignment around indel particularly for ends of reads
    * Within 4-base deletion present on one chromosome in the normal
    * Chromosome without the deletion is lost in the tumour
    * Misalignment problem also evident in the normal but to lesser extent
    * CaVEMan GI filter should take care of this but the germline indel reported by Pindel is 1:169147078-169147078 whereas it should be 1:169147078-169147081
    * Not called by MuTect2 which performs local reassembly
    * Also note that the GATK IndelRealigner tool does a good job of cleaning up the alignments so if this had been carried out before running the CGP pipeline this SNV would almost certainly not have been called
    * GATK IndelRealigner tool does a good job of cleaning up the alignments
    * <span style="color: #e60000">*FALSE*</span>

<div style="line-height: 20%;"><br></div>

6. **chr14:106457339 T>C**
    * [IGV](http://localhost:60151/goto?locus=14:106457339)
        * _Load repeat annotations by clicking on `Load from Server...` from the `File` menu and selecting `dbSNP` annotations within `Variation and Repeats` section_
        * _Click on the SNP annotation at this location to bring up the dbSNP web page for this polymorphism and look at prevalence in 1000 Genomes population_
    * Low depth in the normal is the main concern here - is this really somatic or could it be germline?
    * Probability of having 11 of 11 reads with reference allele if this was a heterozygous germline variant is low (0.0005) but consider that there may be several germline positions that have only been sequenced to low depth in the normal (dangers of not sequencing the normal to sufficient depth)
    * There is a dbSNP entry for the C/T polymorphism at this location with a population allele frequency of 0.2718 within the 1000 Genomes population
    * <span style="color: #29a329">*TRUE*</span>

<div style="line-height: 20%;"><br></div>

7. **chr7:140934248 G>A**
    * [IGV](http://localhost:60151/goto?locus=7:140934248)
        * _Pan right to point where there is a small drop in the coverage in the tumour and sort by insert size_
    * Cluster of G>A substitutions in vicinity
    * Variant reads all show consistent pattern of G>A mismatches while reference reads do not
    * Likely misalignment due to rearrangement
    * BRASS calls an inversion at 7:149934344 but breakpoint appears to be at 7:149934367 (split read alignments)
    * cgpCaVEManPostProcessor filters out G>A calls close to the breakpoint with SE filter (Coverage >= 10 on each strand but mutant allele is only present on one strand)
    * <span style="color: #e60000">*FALSE*</span>

<div style="line-height: 20%;"><br></div>

8. **chr4:22961617 A>T**
    * [IGV](http://localhost:60151/goto?locus=4:22961617)
        * _Zoom out and turn on colouring of reads base insert size and orientation_
        * _Select `Show soft-clipped bases` in alignment view preferences dialog (`View > Preferences > Alignments`)_
    * Variant allele towards end of aligned portion of reads, many of which have clipped alignments
    * Zoom out to see that there are discordant read pairs suggestive of 7.6kb deletion with variant at or very close to breakpoint
    * <span style="color: #e60000">*FALSE*</span>

<div style="line-height: 100%;"><br></div>


---
title: "Exercise: Assessing and Evaluating SNV Calls"
author: "Matt Eldridge and Mark Dunning"
date: "July 2017"
output: html_document
---

### Introduction

The purpose of this practical is to get you familiar with visualising somatic SNV calls in IGV, and to assess whether they are genuine calls or technical artefacts. 

You might find this [set of hints](https://rawgit.com/bioinformatics-core-shared-training/cruk-summer-school-2017/master/Day3/somatic_snv_assessment_igv_tips.html) useful when assessing the calls.

### Preparation

Open the IGV genome browser.

* Load the Tumour `.bam` file `/data/HCC1143.bam`

* Load the Normal `.bam` file `/data/HCC1143_BL.bam`

* Load the `.vcf` file containing variants called by Caveman for this tumour /normal pair `/home/participant/Course_Materials/Day3/HCC1143_vs_HCC1143_BL.annot.muts.vcf.gz`

* Load annotations from the IGV server by choosing `Load from Server...` from the `File` menu
    * Select the `dbSNP` and `Repeat Masker` options within the `Variation and Repeats` annotations section

All but one of the following set of candidate somatic SNVs were called by CaVEMan. The VCF track shows whether the call was made by CaVEMan; hovering over the bar representing the call will bring up a tooltip with details of the SNV call including whether it was filtered.

Click on the `IGV` link for each variant in turn to navigate to that genomic location in the IGV browser. Review the read alignments supporting the variant and those in the region surrounding the variant to decide on your confidence in the call. Click on the `Vote` link to register your decision anonymously.

### Candidate SNVs

<div style="line-height: 50%;"><br></div>

1. chr8:142486034 C>T
    * [IGV](http://localhost:60151/goto?locus=8:142486034)
    * <a target="_blank" href="https://docs.google.com/forms/d/e/1FAIpQLSe2LQZRl1OE_SwXNc7L5t1YABG1MccnfoUvfnAnIBBbxFaroA/viewform">Vote</a>

<div style="line-height: 20%;"><br></div>

2. chr19:14860710 C>T
    * [IGV](http://localhost:60151/goto?locus=19:14860710)
    * <a target="_blank" href="https://docs.google.com/forms/d/e/1FAIpQLSdpcUUnDPwWlHDydXlILnSL-qxhO_y4UkAZccv2l8ONSvbLCg/viewform">Vote</a>

<div style="line-height: 20%;"><br></div>

3. chr8:50114475 T>G
    * [IGV](http://localhost:60151/goto?locus=8:50114475)
    * <a target="_blank" href="https://docs.google.com/forms/d/e/1FAIpQLSfqo7oZkTdYNCsF6Xjuvwd47ruqMw7kKPOssBwDV_NVhls3SA/viewform">Vote</a>

<div style="line-height: 20%;"><br></div>

4. chr3:45153669 C>A
    * [IGV](http://localhost:60151/goto?locus=3:45153669)
    * <a target="_blank" href="https://docs.google.com/forms/d/e/1FAIpQLSfIDyY_r4GA8plwhOiFrHn64LZ6pbf_YKk-dgFdE8L7oecowQ/viewform">Vote</a>

<div style="line-height: 20%;"><br></div>

5. chr1:169147080 T>G
    * [IGV](http://localhost:60151/goto?locus=1:169147080)
    * <a target="_blank" href="https://docs.google.com/forms/d/e/1FAIpQLSfXAJSAmh4QwlH6g-6QSf2Csg_xupu6G48UcDItrctHW2h7Zw/viewform">Vote</a>

<div style="line-height: 20%;"><br></div>

6. chr14:106457339 T>C
    * [IGV](http://localhost:60151/goto?locus=14:106457339)
    * <a target="_blank" href="https://docs.google.com/forms/d/e/1FAIpQLSfA-w_-WN34nEhSIaqzdpThmmqDrEIB2YZKcsuSuyUALNL27A/viewform">Vote</a>

<div style="line-height: 20%;"><br></div>

7. chr7:140934248 G>A
    * [IGV](http://localhost:60151/goto?locus=7:140934248)
    * <a target="_blank" href="https://docs.google.com/forms/d/e/1FAIpQLSexqNn9I7BaSWvi4b9QzG64xzqERjlojCuao4-4qVzQfA3x1Q/viewform">Vote</a>

<div style="line-height: 20%;"><br></div>

8. chr4:22961617 A>T
    * [IGV](http://localhost:60151/goto?locus=4:22961617)
    * <a target="_blank" href="https://docs.google.com/forms/d/e/1FAIpQLSevOKAdDXMQ0IikRJPubQNTkZm3GYMKSdgOpdb7tKP_Ca1w_w/viewform">Vote</a>

<div style="line-height: 100%;"><br></div>

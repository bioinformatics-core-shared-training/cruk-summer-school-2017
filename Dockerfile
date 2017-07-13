FROM bioconductor/release_base2
MAINTAINER Mark Dunning<mark.dunning@cruk.cam.ac.uk>

RUN rm -rf /var/lib/apt/lists/
RUN apt-get update 
RUN apt-get install --fix-missing -y git samtools fastx-toolkit python-dev cmake bwa

## Download and install fastqc

WORKDIR /tmp
RUN wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.3.zip -P /tmp
RUN unzip fastqc_v0.11.3.zip
RUN sudo chmod 755 FastQC/fastqc
RUN ln -s $(pwd)/FastQC/fastqc /usr/bin/fastqc


## Make directory structure
RUN mkdir -p /home/participant/Course_Materials/Day1
RUN mkdir -p /home/participant/Course_Materials/Day2
RUN mkdir -p /home/participant/Course_Materials/Day3
RUN mkdir -p /home/participant/Course_Materials/Day4
RUN mkdir -p /home/participant/Course_Materials/data
RUN mkdir -p /home/participant/Course_Materials/ref_data/annovar

## Install required R packages
COPY installBioCPkgs.R /home/participant/Course_Materials/
RUN R -f /home/participant/Course_Materials/installBioCPkgs.R

## Create directories for each day
COPY Day1/* /home/participant/Course_Materials/Day1/
COPY Day2/* /home/participant/Course_Materials/Day2/
COPY Day3/* /home/participant/Course_Materials/Day3/
COPY Day4/* /home/participant/Course_Materials/Day4/

## Create data directory
COPY data/* /home/participant/Course_Materials/data/




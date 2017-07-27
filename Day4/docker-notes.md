# Running NGS tools and workflows with Docker

![](https://www.docker.com/sites/default/files/vertical_large.png)

## What is all this Docker business?

[Docker](https://www.docker.com) is an open platform for developers to build and ship applications, whether on laptops, servers in a data center, or the cloud.

- Or, it is a (relatively) painless way for you to install and try out Bioinformatics software. 
- You can think of it as an isolated environment inside your exising operating system where you can install and run software without messing with the main OS
- Really useful for testing software
- Clear benefits for working reproducibly
    + instead of just distributing the code used for a paper, you can effectively share the computer you did the analysis on
- For those of you that have used Virtual Machines, it is a similar concept

## Installing Docker

### Mac

- [Mac OSX - 10.10.3 or newer](https://www.docker.com/docker-mac)
- [Older Macs](https://download.docker.com/mac/stable/DockerToolbox.pkg)

### Windows

- [Windows 10](https://www.docker.com/docker-windows)
    + also requires some virtualisation settings
- [Older Windows](https://download.docker.com/win/stable/DockerToolbox.exe)


Once you have installed Docker using the insructions above, you can open a terminal (Mac) or command prompt (Windows) and run the following to download a container for the Ubuntu operating system;

```
docker pull ubuntu
```

To run any software inside the container we can do;

```
docker run ubuntu echo "Hello World"
```

- run the docker container for the Ubuntu operating system
- run the `echo` command within this operating system
- exit

To use the container in interactive mode we have to specify a `-it` argument. Which basically means that it doesn't exit straight away, but instead runs the `bash` command to get a terminal prompt

*NB* the `--rm` means that the container is deleted on exit, otherwise your disk could get clogged up with lots of exited containers

```
docker run -it --rm ubuntu
```


## The Sanger Docker

The Sanger CGP docker container packages a complete environment including all the tools to run the CGP analysis pipeline. These tools include:

* **CaVEMan** for identifying somatic SNVs
* **Pindel** for identifying somatic indels (short insertions and deletions)
* **ASCAT** for detecting copy number changes
* **BRASS** for identifying somatic genomic rearrangements, also known as structural variants (SVs)


The container being used is called `quay.io/wtsicgp/dockstore-cgpwgs:1.0.8`. There are some minimal instructions [here](https://dockstore.org/containers/quay.io/wtsicgp/dockstore-cgpwgs).

Once inside the container we can run any tools that have been installed. However, what is not included is *data* and by default the file system is completely isolated from our own machine. In order to analyse our own data we *mount* directories on our own OS so they are available within the Docker environment. 

- the `-v` argument to `docker run` allows certain directories on your machine to be visible inside docker. 
	+ -v FROM:TO
	+ where FROM is located on your operating system, TO is within docker


On Day3, we ran CaVEMan using the ***Sanger Docker*** shortcut. What this was actually doing is below.

```
docker run \
--rm \
-it --entrypoint=bash \
-v /data:/data \
-v /reference_data:/reference_data \
-v /home/participant/Course_Materials/Day3:/caveman_practical \
quay.io/wtsicgp/dockstore-cgpwgs:1.0.8
```



## Running the Sanger Somatic pipeline

However, the intended usage for this container is to run the entire pipeline on a matched tumour and normal sample. The tools listed above are used in an automated fashion as a *workflow* with, say, the output of ascat being automatically passed to caveman etc.

To run the pipeline, we need another piece of software called [`cwltool`](https://github.com/common-workflow-language/cwltool) and a configuration file that will define the locations of the input tumour and normal files, reference data, and where the output is to be stored. Installing `cwltool` itself requires Python. Some notes are given below for this procedure.


To ensure that the pipeline runs in reasonable time, we have provided a *downsampled* version of the HCC1143 cell-line and its matched normal in the directory `/data/downsampled`. We have also downloaded the reference files required by the pipeline to `/reference_data` (the url for these files can be found in the script `/home/participant/Course_Materials/download-ref-data.sh`)

***This time open a Terminal using the icon on the left-side of the Desktop***

```
ls /data/downsampled
ls /reference_data
```

The config file to run the pipeline can be found in the directory `/home/participant/Course_Materials/pipeline_test/`

```
cd /home/participant/Course_Materials/pipeline_test
cat cgpwgs.json
```
Which should look something like:-

```
{
  "normal": {
    "path": "/data/downsampled/HCC1143_BL.bam",
    "class": "File"
  },
    "species": "human",
  "tumour": {
    "path": "/data/downsampled/HCC1143.bam",
    "class": "File"
  },
  "subcl": {
    "path": "/reference_data/SUBCL_ref_GRCh37d5.tar.gz",
    "class": "File"
  },
  "cnv_sv": {
    "path": "/reference_data/CNV_SV_ref_GRCh37d5.tar.gz",
    "class": "File"
  },
  "cavereads": 350000,
  "annot": {
    "path": "/reference_data/VAGrENT_ref_GRCh37d5_ensembl_75.tar.gz",
    "class": "File"
  },
  "skipbb": false,
  "reference": {
    "path": "/reference_data/core_ref_GRCh37d5.tar.gz",
    "class": "File"
  },
  "snv_indel": {
    "path": "/reference_data/SNV_INDEL_ref_GRCh37d5.tar.gz",
    "class": "File"
  },

  "assembly": "GRCh37d5",
  "timings": {
    "path": "/home/participant/pipeline_test/timings_WGS.tar.gz",
    "class": "File"
  },
  "exclude": "NC_007605,hs37d5,GL%",
    "run_params": {
    "path": "/home/participant/pipeline_test/params.txt",
    "class": "File"
  },
  "global_time": {
    "path": "/home/participant/pipeline_test/global_WGS.time",
    "class": "File"
  },
  "result_archive": {
    "path": "/home/participant/pipeline_test/result_WGS.tar.gz",
    "class": "File"
  },
  "sv_cyto": {
    "path": "/reference_data/cytoband_GRCh37d5.txt",
    "class": "File"
  }
}


```

The command to run the pipeline is taken from the [Dockstore](https://dockstore.org/containers/quay.io/wtsicgp/dockstore-cgpwgs) page for the tool.

```cat cgpwgs.sh
```

```
mkdir -p tmp
mkdir -p output

cwltool \
	--leave-container \
	--leave-tmpdir \
	--copy-outputs \
	--tmpdir-prefix /home/participant/pipeline_test/tmp/ \
	--tmp-outdir-prefix /home/participant/pipeline_test/output/ \
	--non-strict \
	https://www.dockstore.org:8443/api/ga4gh/v1/tools/quay.io%2Fwtsicgp%2Fdockstore-cgpwgs/versions/1.0.8/plain-CWL/descriptor \
	cgpwgs.json

```

You can run this script as below. If all goes well, we should have some results to look at in the morning :tada:


```
./cgpwgs.sh
```


### Sanger pipeline checklist

- Install docker
- Install cwltool
	+ requires Python and `pip`
- Modify the `json` file to include the paths to your tumour and normal files
- Check the paths to the reference data
- Use the `./cgpwgs.sh` command to run the pipeline
	+ it should download the Sanger Docker container if you don't have it
	
### cwltool install on Mac OSX	

- Install [homebrew](https://brew.sh/). This will allow you to install Python easily
- Install python
```
brew install python
```
- Install `pip`; python package manager system
	+ download the script [get-pip.py](https://bootstrap.pypa.io/get-pip.py)
	+ run `get-pip.py` with python
	```
	python get-pip.py
	```
- Now use `pip` to install `cwltool`


## The CRUK Docker

We have collected several useful NGS tools into one environment for the purposes of this course

- samtools
- fastqc
- freebayes
- and more....

To download the ***CRUK Docker*** onto your computer you run the following. It should tell you that it is downloading various *layers* and show some progress bars

```
docker pull markdunning/cancer-genome-toolkit
```

- when you click the ***CRUK Docker*** icon on the Desktop, what is being run is actually:-

```
docker run \
--rm \
-it --entrypoint=bash \
-v /data:/data \
-v /reference_data:/reference_data \
-v /home/participant/Course_Materials:/home/participant/Course_Materials \
-v /home/participant/software:/home/participant/Course_Materials/software \
markdunning/cancer-genome-toolkit
```

The machines used in Genetics for the course already happen to have a `/data/` and `/reference_data/` directory. However, when you try and run the course on your own machine, you will need to type the paths to where you have stored the data from the course. If you wish to run `annovar` as described in the class you will need to [download it](http://annovar.openbioinformatics.org/en/latest/user-guide/download/) and extract into a folder on your laptop `/PATH/TO/YOUR/software`.

```
docker run \
--rm \
-it --entrypoint=bash \
-v /PATH/TO/YOUR/data:/data \
-v /PATH/TO/YOUR/reference_data:/reference_data \
-v /PATH/TO/YOUR/Course_Materials:/home/participant/Course_Materials \
-v /PATH/TO/YOUR/software:/home/participant/Course_Materials/software \
markdunning/cancer-genome-toolkit
```

As we have provided a hard drive with the data, the command would look something like this on a Mac:-

```
docker run \
--rm \
-it --entrypoint=bash \
-v /Volumes/CRUKSummer/data:/data \
-v /Volumes/CRUKSummer/reference_data:/reference_data \
-v /Volumes/CRUKSummer/Course_Materials:/home/participant/Course_Materials \
-v /Volumes/CRUKSummer/software:/home/participant/Course_Materials/software \
markdunning/cancer-genome-toolkit


```
And on Windows it will depend on what drive letter the external hard drive appears as. So if the D drive is used:-

```
docker run \
--rm \
-it --entrypoint=bash \
-v D:/CRUKSummer/YOUR_USERNAME/data:/data \
-v D:/CRUKSummer/YOUR_USERNAME/reference_data:/reference_data \
-v D:/CRUKSummer/YOUR_USERNAME/Course_Materials:/home/participant/Course_Materials \
-v D:/CRUKSummer/YOUR_USERNAME/software:/home/participant/Course_Materials/software \
markdunning/cancer-genome-toolkit

```
You don't just have to use the container with the data shipped with the course. If you have other files that you want to play with you just need to change the first line that uses`-v`

### Checklist for using the CRUK Docker on your own machine

- Install Docker
- `docker pull markdunning/cancer-genome-toolkit`
- work out where the data you want to analyse are located and modify the `-v` arguments accordingly


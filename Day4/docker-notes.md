# Running NGS tools and workflows with Docker

![](https://www.docker.com/sites/default/files/vertical_large.png)

## What is all this Docker business?

[Docker](https://www.docker.com) is an open platform for developers to build and ship applications, whether on laptops, servers in a data center, or the cloud.

- Or, it is a (relatively) painless way for you to install and try out Bioinformatics software. 
- Once you have installed Docker, any exisintg tools and environments packaged with docker can be installed and run with a single command
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


## The CRUK Docker

We have collected several useful NGS tools into one environment for the purposes of this course

- samtools
- fastqc
- freebayes
- and more....

Once you have installed Docker using the insructions above, you can open a terminal (Mac) or command prompt (Windows) and run the following to check that everything is working, which will

- run the docker container for the Ubuntu operating system
- run the `echo` command within this operating system
- exit


```
docker run ubuntu echo "Hello World"
```

To download the CRUK docker onto your computer you run the following. It should tell you that it is downloading various *layers* and show some progress bars

```
docker pull markdunning/cancer-genome-toolkit
```

To use the container in interactive mode we have to specify a `-it` argument. Which basically means that it doesn't exit straight away, but instead runs the `bash` command to get a terminal prompt

*NB* the `--rm` means that the container is deleted on exit

```
docker run --rm -it markdunning/cancer-genome-toolkit bash
```

Once inside the container we can run any tools that have been installed. However, what is not included is *data*. In order to use the Docker container to analyse our own data. This is achieved by *mounting* directories within our own OS so they are available within the Docker environment. 

- the `-v` argument to `docker run` allows certain directories on your machine to be visible inside docker. 
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

The machines used in Genetics for the course already happen to have a `/data/` and `/reference_data/` directory. However, when you try and run the course on your own machine, you will need to type the paths to where you have stored the data from the course.

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
And on Windows it will depend on what drive letter the external hard drive appears as:-

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


## The Sanger Docker

The Sanger CGP docker image packages a complete environment including all the tools to run the CGP analysis pipeline. These tools include:

* **CaVEMan** for identifying somatic SNVs
* **Pindel** for identifying somatic indels (short insertions and deletions)
* **ASCAT** for detecting copy number changes
* **BRASS** for identifying somatic genomic rearrangements, also known as structural variants (SVs)

On Day3, we ran CaVEMan using the 

```
docker run \
	--rm \
	-it --entrypoint=bash \
	-v ${PWD}:/caveman_practical \
	-v /PATH_TO/HCC1143:/data \
	-v /PATH_TO/reference_data:/reference_data \
	quay.io/wtsicgp/dockstore-cgpwgs:1.0.8
```

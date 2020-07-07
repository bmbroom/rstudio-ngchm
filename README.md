# rstudio-ngchm
rstudio-ngchm is a derivative of [rocker/rstudio](https://hub.docker.com/r/rocker/rstudio/) that includes preinstalled copies of the Next-Generation Clustered Heat Map (NGCHM) viewer and R library.  It is primarily an easy way for prospective users of the NGCHM/R environment to test the software easily.  You can also download and install the software into your own RStudio environment.

## Quick start

Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop) (if you're on a Windows/Mac) or docker (on Linux) for your environment.  Docker and Docker Desktop are an easy way to run (and remove) prepackaged software `containers` on your computer.

Once Docker/Docker Desktop is up and running:

* Pull the NGCHM/RSTUDIO image:
```sh
  docker pull ngchm/rstudio-ngchm
```
* Create folder to share with the container:
```sh
  mkdir /tmp/rstudio
```
* Run the docker container (Mac/Linux):
```
  docker run -d -p 8787:8787 -v /tmp/rstudio:/home/rstudio -e USERID=`id -u` -e GROUPID=`id -g` -e PASSWORD=yourpassword ngchm/rstudio-ngchm
```
* Run the docker container (Windows):
```sh
docker run -d -p 8787:8787 -v "C:/path.to.directory":/home/rstudio -e PASSWORD=yourpassword ngchm/rstudio-ngchm
```

When the container is running:

* Connect to it by opening [http://localhost:8787](http://localhost:8787) in your browser, and
* Login using login id "rstudio" and the password you supplied above.

Instructions for using the NGCHM R Package are available in [this Youtube video](https://www.youtube.com/watch?v=O42w5P3A1_8).

## Features

NGCHM's allow the user to visualize and explore potentially very-large (tens of thousands of elements / axis) heat maps.  Their key features are:

* Extreme zooming without loss of resolution for drill-down into large data matrices
* Fluent navigation
* Link-outs from labels or pixels to more than 25 annotation resources (such as GeneCards, NCBI, cBioPortal)
* Flexible real-time recoloring of the map
* Annotation with pathway data
* Capture of all metdadata needed to reproduce any chosen state of the map
* A multi-faceted exploratory environment for analysis and interpretation of omic data.

Although developed for exploring genome-scale omic data, NGCHM's are agnostic to the data domain and can be used to visualize and explore large data matrices from any application domain.

This [brief video](https://www.youtube.com/watch?v=DuObpGNpDhw) briefly describes the key features of the NGCHM system.  Our [Youtube channel](https://www.youtube.com/channel/UCADGir2q8IaI9cGQuzjSL9w/videos) includes many other videos about the NGCHM system.

## Images with Additional R Packages Preinstalled

In addition to the base image (ngchm/rstudio-ngchm), we also provide additional images with additional R packages preinstalled:

* ngchm/rstudio-ngchm-bioc which has the Bioconductor and TCGAbiolinks R packages preinstalled
* ngchm/rstudio-ngchm-sc which also has the single-cell R packages Seurat and singleCellTK preinstalled

## Versions

The version tag on the images reflects the version number of the R system included in the RStudio container.

New images with updated NGCHM, Bioconductor, or other packages/tools might be uploaded to Docker Hub under the same tag.  Please tag the image
with your own immutable identifier if you need a permanent reference to a specific image.

## Browser support

Our goal is to support all major browsers up to a year old.

## Contributing

We welcome contributions to the NGCHM system, including

* Bug reports
* Feature requests (including popular R packages that should be included in an image)
* Pull requests

Please direct contributions as follows:

* Regarding the NGCHM viewer to the [NGCHM Github](https://github.com/MD-Anderson-Bioinformatics/NG-CHM) page,
* Regarding the NGCHM R package to the [NGCHM-R Github](https://github.com/MD-Anderson-Bioinformatics/NGCHM-R) page,
* Regarding the integration with RStudio to this page.

## About the Dockerfiles

To minimize the time required to rebuild the docker images when the NGCHM system or R package are updated, I have created
a sequence of Dockerfiles that progressively build docker images with more features (core build, with Bioconductor, with single cell packages).
These images have tags that include "pre".  They are not meant to be run and are not uploaded to docker hub.

The Dockerfile.add-ngchm then adds the NGCHM system and R package to each of these.  See the build-rstudio script for details.

## License

The NGCHM code is available under the GNU General Public License, version 2.

FROM rocker/rstudio

RUN apt-get update && apt-get -y install libxml2-dev openjdk-7-jre-headless && apt-get -y clean

COPY install.R /tmp/install.R

RUN Rscript /tmp/install.R && /bin/rm /tmp/install.R

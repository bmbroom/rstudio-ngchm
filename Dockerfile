# Multistage build.

# Import NGCHM build artifacts
FROM ngchm/ngchm:latest AS ngchm

# Preinstall the NGCHM R library into an rstudio container.

# To run:
# - Follow the instructions at https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image
#   but substitute bmbroom/rstudio-ngchm for the name of the docker image.
# - Open the rstdio port (default 8787) in your browser and login (default rstudio/rstudio).
# - Load the NGCHM library: library(NGCHM)
# - Connect to your NGCHM server (see https://github.com/bmbroom/NGCHMR/blob/master/README.md
#   for pointers to documentation).

FROM rocker/rstudio

MAINTAINER Bradley Broom <bmbroom@mdanderson.org>

RUN echo "SHAIDYMAPGEN=/NGCHM/shaidymapgen/ShaidyMapGen.jar" >> /usr/local/lib/R/etc/Renviron

# Define utility function to display viewer.
RUN echo 'chmViewer <- function() { rstudioapi::viewer(file.path(tempdir(), "ngChmApp.html")); }' >> /usr/local/lib/R/etc/Rprofile.site

# Show the user a little help.
RUN echo 'cat ("Type' "'chmViewer()'" 'to open the standalone NG-CHM viewer.\n");' >> /usr/local/lib/R/etc/Rprofile.site
RUN echo 'cat ("Type' "'help(package=NGCHM)'" 'to show documentation for the NG-CHM package.\n");' >> /usr/local/lib/R/etc/Rprofile.site

# Workaround hack in RStudio that breaks ShaidyMapGen
RUN echo 'Sys.setenv("DISPLAY"="");' >> /usr/local/lib/R/etc/Rprofile.site

RUN apt-get update \
 && apt-get -y install libssl-dev openssh-client libssh2-1-dev libxml2-dev openjdk-8-jre-headless zlib1g-dev \
 && apt-get -y clean

RUN sh -c 'cd /root && git clone https://github.com/ropensci/git2r.git && cd git2r && make install'

RUN Rscript \
 -e 'install.packages("devtools")' \
 -e 'devtools::install_github(c("bmbroom/tsvio@stable","bmbroom/NGCHMR@master"))'

# Copy all NGCHM build artifacts into this image.
COPY --from=ngchm /NGCHM /NGCHM/
# Copy viewer to a place RStudio can serve it.
RUN echo 'system2("cp", c("/NGCHM/standalone/ngChmApp.html",tempdir()));' >> /usr/local/lib/R/etc/Rprofile.site


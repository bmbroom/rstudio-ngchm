# Multistage build.

# Import NGCHM build artifacts
FROM ngchm/ngchm:2.16.0 AS ngchm

# Preinstall the NGCHM R library into an rstudio container.

# To run:
# - Follow the instructions at https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image
#   but substitute bmbroom/rstudio-ngchm for the name of the docker image.
# - Open the rstdio port (default 8787) in your browser and login (default rstudio/rstudio).
# - Load the NGCHM library: library(NGCHM)
# - Connect to your NGCHM server (see https://github.com/bmbroom/NGCHMR/blob/master/README.md
#   for pointers to documentation).

FROM rocker/rstudio:3.6.2

MAINTAINER Bradley Broom <bmbroom@mdanderson.org>

RUN echo "SHAIDYMAPGEN=/NGCHM/shaidymapgen/ShaidyMapGen.jar" >> /usr/local/lib/R/etc/Renviron

# Define utility function to display viewer.
RUN echo 'chmViewer <- function() { rstudioapi::viewer(file.path(tempdir(), "ngChmApp.html")); }' >> /usr/local/lib/R/etc/Rprofile.site

# Show the user a little help.
RUN echo 'message ("Type' "'chmViewer()'" 'to open the standalone NG-CHM viewer.\n");' >> /usr/local/lib/R/etc/Rprofile.site
RUN echo 'message ("Type' "'help(package=NGCHM)'" 'to show documentation for the NG-CHM package.\n");' >> /usr/local/lib/R/etc/Rprofile.site

# Workaround hack in RStudio that breaks ShaidyMapGen
RUN echo 'Sys.setenv("DISPLAY"="");' >> /usr/local/lib/R/etc/Rprofile.site

RUN apt-get update \
 && apt-get -y install libssl-dev openssh-client libssh2-1-dev libxml2-dev openjdk-11-jre-headless zlib1g-dev \
 && apt-get -y clean

RUN sh -c 'cd /root && git clone https://github.com/ropensci/git2r.git && cd git2r && make install'

RUN Rscript \
 -e 'install.packages("devtools")' \
 -e 'devtools::install_github(c("bmbroom/tsvio@stable","bmbroom/NGCHMR@master"))'

# Copy all NGCHM build artifacts into this image.
COPY --from=ngchm /NGCHM /NGCHM/
# Copy viewer to a place RStudio can serve it.
RUN echo '\n\
apppath <- file.path(tempdir(), "ngChmApp.html"); \n\
if (Sys.getenv("NGCHM_UPDATE", "true") == "true") {\n\
    warning("NGCHM web update:"); \n\
    appok <- utils::download.file ("https://www.ngchm.net/Downloads/ngChmApp.html", apppath, quiet=TRUE) == 0; \n\
    if (!appok) warning("Unable to download ngChmApp.html. Using default."); \n\
    warning("NGCHM web update finished."); \n\
} else { appok <- FALSE; } \n\
if (!appok) { \n\
    system2("cp", c("/NGCHM/standalone/ngChmApp.html",apppath)); \n\
} \n\
' >> /usr/local/lib/R/etc/Rprofile.site

RUN echo 'echo "NGCHM_UPDATE=$NGCHM_UPDATE" >> /usr/local/lib/R/etc/Renviron\n' >> /etc/cont-init.d/userconf

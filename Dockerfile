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

RUN apt-get update \
 && apt-get -y install libssl-dev openssh-client libssh2-1-dev libxml2-dev openjdk-7-jre-headless \
 && apt-get -y clean

RUN sh -c 'cd /root && git clone https://github.com/ropensci/git2r.git && cd git2r && make install'

RUN Rscript \
 -e 'install.packages("devtools")' \
 -e 'devtools::install_github(c("bmbroom/tsvio@stable","bmbroom/NGCHMR@beta"))'

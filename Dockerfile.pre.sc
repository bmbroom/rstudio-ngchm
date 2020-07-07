ARG RSTUDIOPREBIOC=ngchm/rstudio-ngchm-pre-bioc

FROM ${RSTUDIOPREBIOC}

RUN Rscript -e "options(Ncpus=`nproc`); BiocManager::install('multtest')"
RUN Rscript -e "options(Ncpus=`nproc`); BiocManager::install('SCnorm')"
RUN Rscript -e "options(Ncpus=`nproc`); BiocManager::install('scmap')"

RUN Rscript -e "options(Ncpus=`nproc`); install.packages('metap')"
RUN Rscript -e "options(Ncpus=`nproc`); install.packages('uwot')"
RUN Rscript -e "options(Ncpus=`nproc`); install.packages('Seurat')"

RUN Rscript -e "options(Ncpus=`nproc`); BiocManager::install('singleCellTK')"

RUN Rscript -e 'missing <- setdiff(c("multtest", "SCnorm", "scmap", "metap", "uwot", "Seurat", "singleCellTK"), installed.packages()[,"Package"]); \
                if (length(missing) > 0) stop (paste("Some R packages failed to install: ", paste(missing, collapse=", ")), call.=FALSE)'

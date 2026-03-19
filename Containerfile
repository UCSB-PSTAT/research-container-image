FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt update -y && apt install -y libgdal-dev libproj-dev libmpfr-dev && apt clean

RUN pip install tensorflow tensorflow-cpu tf-keras

# PrevMap requires Terra and raster, which fail to install inside R. So install with mamba instead:
RUN conda install \
    cargo-llvm-cov \
    clarabel \
    keras \
    pytorch \
    r-arrow \
    r-expm \
    r-geosphere \
    r-glmnet \
    r-here \
    r-igraph \
    r-keras \
    r-raster \
    r-rmpfr \
    r-ggraph \
    r-tensorflow \
    r-terra \
    r-tictoc \
    r-tidygraph \
    r-softimpute \
    transformers \
    yt-dlp

# Install packages from CRAN to avoid conda downgrading R version.
RUN R -e "install.packages(c('assist','date','imputeTS'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/zipcode/zipcode_1.0.tar.gz', repos=NULL, type='source', Ncpus = parallel::detectCores())"

RUN /usr/local/bin/fix-permissions "${CONDA_DIR}" || true && chown -R jovyan:users /home/jovyan

USER $NB_USER

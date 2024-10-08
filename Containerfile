FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt update -y && apt install -y libgdal-dev libproj-dev libmpfr-dev && apt clean

# PrevMap requires Terra and raster, which fail to install inside R. So install with mamba instead:
RUN mamba install \
    cargo-llvm-cov \
    clarabel \
    keras \
    r::r-assist \
    r-arrow \
    r::r-date \
    r-expm \
    r-geosphere \
    r-glmnet \
    r-here \
    r-igraph \
    r::r-imputets \
    r-keras \
    r-raster \
    r-rmpfr \
    r-ggraph \
    r-tensorflow \
    r-terra \
    r-tictoc \
    r-tidygraph \
    r-softimpute \
    tensorflow-cpu \
    tf-keras

RUN R -e "install.packages(c('PrevMap', 'softImpute'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/zipcode/zipcode_1.0.tar.gz', repos=NULL, type='source', Ncpus = parallel::detectCores())"

RUN pip install 'transformers[torch]'

USER $NB_USER


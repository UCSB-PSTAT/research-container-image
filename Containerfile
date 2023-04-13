FROM ucsb/rstudio-base:latest

LABEL maintainer="LSIT Systems <lsitops@ucsb.edu>"

USER root

RUN apt install -y libgdal-dev libproj-dev && apt clean

RUN R -e "install.packages(c('assist', 'date', 'geosphere', 'glmnet', 'PrevMap', 'tictoc', 'expm', 'imputeTS'), repos = 'https://cloud.r-project.org/', Ncpus = parallel::detectCores())"

RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/zipcode/zipcode_1.0.tar.gz', repos=NULL, type='source', Ncpus = parallel::detectCores())"

RUN pip install 'transformers[torch]'

USER $NB_USER


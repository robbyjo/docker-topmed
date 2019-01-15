# By Roby Joehanes
# License: GPL-3.0


FROM robbyjo/r-mkl-full:3.5.2-18.04-2019.1
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install netcdf-bin libnetcdf-dev libxml2-dev ed libssh2-1-dev zip unzip libicu-dev libmariadb-client-lgpl-dev && \
  cd /home && \
  wget -q http://ab-initio.mit.edu/nlopt/nlopt-2.5.0.tar.gz && \
  tar -zxf nlopt-2.5.0.tar.gz && \
  cd nlopt-2.5.0 && \
  ./configure CFLAGS="-g -O3 -fPIC" CXXFLAGS="-g -O3 -fPIC" --enable-shared && make && make install && \
  cd /home && rm -rf nlopt-* && \
  wget --no-check-certificate -q https://cran.r-project.org/src/contrib/Archive/kinship/kinship_1.1.3.tar.gz && \
  R CMD INSTALL --no-docs --no-demo --byte-compile kinship_1.1.3.tar.gz && \
  rm kinship_1.1.3.tar.gz && \
  cd /home && \
  echo "pedigreemm,data.table,filematrix,kinship2,coxme,plyr,reshape2,ggplot2,SuppDists,gee,geepack,betareg,censReg,gamlss,MASS,mlogit,logistf,pscl,quantreg,robust,survival,truncreg,Zelig,ZeligChoice,ZeligEI,zoo,car,metafor,pls,pspearman,mice,mediation,moments,randomForest,lubridate,tidyr,sqldf,SKAT,seriation,R.utils,e1071,Hmisc,grImport,lavaan,bnlearn,devtools,doMC,lars,ncdf4,Matrix,foreign,robustlmm,argparse,openxlsx,zip,xfun,formatR,yaml,stringi,stringr,magrittr,glue,mime,markdown,highr,knitr,jsonlite,htmltools,shiny" | tr ',' '\n' > /home/pkgs.txt && \
  echo "pkgs <- read.csv('/home/pkgs.txt', header=FALSE, as.is=TRUE)[,1];" > instpkgs.R && \
  echo "print(pkgs);" >> instpkgs.R && \
  echo "install.packages(pkgs, repos='https://cloud.r-project.org/', clean=TRUE, INSTALL_opts='--no-docs --no-demo --byte-compile');" >> instpkgs.R && \
  echo "cat('\n\n\n\n\n\nsessionInfo:\n');" >> instpkgs.R && \
  echo "print(sessionInfo());" >> instpkgs.R && \
  echo "cat('\n\n\n\n\n\nInstalled packages:\n');" >> instpkgs.R && \
  echo "tbl <- installed.packages()[,3, drop=FALSE];" >> instpkgs.R && \
  echo "print(tbl);" >> instpkgs.R && \
  echo "b <- !(pkgs %in% rownames(tbl));" >> instpkgs.R && \
  echo "if (sum(b) > 0) {" >> instpkgs.R && \
  echo "    cat('\n\n\n\n\n\nThe following packages were not installed:\n');" >> instpkgs.R && \
  echo "    print(pkgs[b]);" >> instpkgs.R && \
  echo "} else {" >> instpkgs.R && \
  echo "    cat('\n\n\n\n\n\nAll intended packages were installed!\n');" >> instpkgs.R && \
  echo "}" >> instpkgs.R && \
  Rscript --vanilla /home/instpkgs.R && \
  rm -Rf /home/*
  

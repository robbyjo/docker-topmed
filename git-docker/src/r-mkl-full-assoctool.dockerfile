# By Roby Joehanes
# License: GPL-3.0


FROM robbyjo/r-mkl-full:3.5.2-18.04-2019.1
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

RUN cd /home && \
  echo "pedigreemm,kinship2,coxme,gee,geepack,betareg,censReg,gamlss,mlogit,logistf,pscl,quantreg,robust,truncreg,Zelig,ZeligChoice,ZeligEI,zoo,metafor,robustlmm,pls,pspearman,mediation,moments,randomForest,lubridate,tidyr,sqldf,SKAT,seriation,e1071,lavaan,bnlearn,doMC,lars,ncdf4,foreign,openxlsx,xfun,formatR,yaml,stringi,stringr,magrittr,glue,mime,markdown,highr,knitr,jsonlite,htmltools" | tr ',' '\n' > /home/pkgs.txt && \
  echo "pkgs <- read.csv('/home/pkgs.txt', header=FALSE, as.is=TRUE)[,1];" > instpkgs.R && \
  echo "pkgs <- setdiff(pkgs, rownames(installed.packages()));" >> instpkgs.R && \
  echo "print(paste0('Number of cores: ', parallel::detectCores()));" >> instpkgs.R && \
  echo "options(Ncpus = parallel::detectCores());" >> instpkgs.R && \
  echo "print(pkgs);" >> instpkgs.R && \
  echo "install.packages(pkgs, repos=c('CRAN'='https://cran.rstudio.com/'), clean=TRUE, INSTALL_opts='--no-docs --no-demo --byte-compile');" >> instpkgs.R && \
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

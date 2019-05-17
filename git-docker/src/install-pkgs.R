# Install assoctool packages needed for Docker
# Author: Roby Joehanes
# License: GPL v3 https://www.gnu.org/licenses/gpl-3.0.en.html
# This is for R v3.6 and up

pkgs <- "pedigreemm,kinship2,coxme,gee,geepack,betareg,censReg,gamlss,mlogit,logistf,pscl,quantreg,robust,truncreg,Zelig,ZeligChoice,ZeligEI,zoo,metafor,robustlmm,pls,pspearman,mediation,moments,randomForest,lubridate,tidyr,sqldf,SKAT,seriation,e1071,lavaan,bnlearn,doMC,lars,ncdf4,foreign,openxlsx,xfun,formatR,yaml,stringi,stringr,magrittr,glue,mime,markdown,highr,knitr,jsonlite,htmltools,devtools";
pkgs <- unlist(strsplit(pkgs, ","));
pkgs <- setdiff(pkgs, rownames(installed.packages()));
print(paste0('Number of cores: ', parallel::detectCores()));
options(Ncpus = parallel::detectCores());
print(pkgs);
install.packages(pkgs, repos=c('CRAN'='https://cran.rstudio.com/'), clean=TRUE, INSTALL_opts='--no-docs --no-demo --byte-compile');
cat('\n\n\n\n\n\nsessionInfo:\n');
print(sessionInfo());
cat('\n\n\n\n\n\nInstalled packages:\n');
tbl <- installed.packages()[,3, drop=FALSE];
print(tbl);
b <- !(pkgs %in% rownames(tbl));
if (sum(b) > 0) {
    cat('\n\n\n\n\n\nThe following packages were not installed:\n');
    print(pkgs[b]);
} else {
    cat('\n\n\n\n\n\nAll intended packages were installed!\n');
}

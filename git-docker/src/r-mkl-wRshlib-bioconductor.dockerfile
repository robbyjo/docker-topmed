# By Roby Joehanes
# License: GPL-3.0


FROM robbyjo/r-mkl-full-assoctool:3.4.2-16.04-2018.0
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

RUN cd /home && \
  echo "SNPRelate,GENESIS,argparser,survey,CompQuadForm,GGally,qvalue,annotate,WGCNA,limma,biomaRt,GWAF,preprocessCore,sva,rhdf5,geneplotter,rtracklayer,genefilter,KEGGgraph,GSEABase,impute,edgeR,DESeq2,GEOquery,multtest,Biostrings,affy,minfi,pcaMethods,biovizBase,graph,BSGenome,BiocParallel,BiocInstaller,OrganismDbi,ExperimentHub,Biobase,ShortRead,IRanges,GenomicRanges,GenomicAlignment,GenomicFeatures,SummarizedExperiment,VariantAnnotation,DelayedArray,Gviz,RBGL,Rgraphviz,rmarkdown,BiocStyle,wateRmelon,githubinstall" | tr ',' '\n' > /home/pkgs.txt && \
  echo "pkgs <- read.csv('/home/pkgs.txt', header=FALSE, as.is=TRUE)[,1];" > instpkgs.R && \
  echo "print(pkgs);" >> instpkgs.R && \
  echo 'source("https://bioconductor.org/biocLite.R")' >> instpkgs.R && \
  echo "biocLite(pkgs, clean=TRUE, INSTALL_opts='--no-docs --no-demo --byte-compile');" >> instpkgs.R && \
  echo "biocLite(ask=FALSE, clean=TRUE, INSTALL_opts='--no-docs --no-demo --byte-compile');" >> instpkgs.R && \
  echo "cat('\n\n\n\n\n\nsessionInfo:\n');" >> instpkgs.R && \
  echo "print(sessionInfo());" >> instpkgs.R && \
  echo "cat('\n\n\n\n\n\nInstalled packages:\n');" >> instpkgs.R && \
  echo "print(installed.packages()[,3, drop=FALSE]);" >> instpkgs.R && \
  Rscript --vanilla /home/instpkgs.R && \
  rm /home/instpkgs.R /home/pkgs.txt

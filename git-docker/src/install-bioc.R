# Install BioConductor packages needed for Docker
# Author: Roby Joehanes
# License: GPL v3 https://www.gnu.org/licenses/gpl-3.0.en.html
# This is for R v3.6 and up

pkgs <- "SNPRelate,GENESIS,argparser,survey,CompQuadForm,GGally,qvalue,annotate,WGCNA,limma,biomaRt,GWAF,preprocessCore,gdsfmt,SeqArray,SeqVarTools,sva,rhdf5,geneplotter,rtracklayer,genefilter,KEGGgraph,GSEABase,impute,edgeR,DESeq2,GEOquery,multtest,Biostrings,affy,minfi,pcaMethods,biovizBase,graph,BSgenome,BiocParallel,BiocInstaller,OrganismDbi,ExperimentHub,Biobase,ShortRead,IRanges,GenomicRanges,GenomicAlignments,GenomicFeatures,SummarizedExperiment,VariantAnnotation,DelayedArray,Gviz,RBGL,Rgraphviz,rmarkdown,BiocStyle,wateRmelon,githubinstall,GEOmetadb";
  
pkgs <- unlist(strsplit(pkgs, ","));
print(pkgs);
pkgs <- setdiff(pkgs, rownames(installed.packages()));
print(paste0('Number of cores: ', parallel::detectCores()));
options(Ncpus = parallel::detectCores());
library(devtools);
# Newer Bioconductor installation script
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager", repos="https://cloud.r-project.org/");
BiocManager::install(ask=FALSE, clean=TRUE, INSTALL_opts='--no-docs --no-demo --byte-compile');
cat('\n\n\n\n\n\nGet the latest greatest gdsfmt / SeqArray:\n');
install_github('zhengxwen/gdsfmt');
install_github('zhengxwen/SeqArray');
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

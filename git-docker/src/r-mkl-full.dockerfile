# By Roby Joehanes
# License: GPL-3.0

FROM robbyjo/ubuntu-mkl:18.04-2019.1
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

# Easier way to build R dependencies are below, but this will result in a bulky build.
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && \
  DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y build-dep r-base-dev && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install libcurl4-openssl-dev sysstat libssl-dev  cmake netcdf-bin libnetcdf-dev libxml2-dev ed libssh2-1-dev zip unzip libicu-dev libmariadb-client-lgpl-dev && \
  DEBIAN_FRONTEND=noninteractive apt-get -y remove libblas3 libblas-dev && \
# Instead of relying on Ubuntu Trusty's libpcre 8.31 (which is deemed obsolete by R),
# Try to install 8.42 manually
  sed -e "s/false/true/g" /etc/default/sysstat > /etc/default/sysstat.bak && \
  mv /etc/default/sysstat.bak /etc/default/sysstat && \
  /etc/init.d/sysstat start && \
  cd /home && wget -q ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.42.tar.gz && \
  tar -zxf pcre-8.42.tar.gz && cd pcre-8.42 && \
  ./configure --enable-pcre16 --enable-pcre32 --enable-jit --enable-utf --enable-pcregrep-libz --enable-pcregrep-libbz2 --enable-pcretest-libreadline && \
  make && make install && cd /home && rm -rf /home/pcre* && \
  ln -sf /opt/intel/lib/intel64/libiomp*.so /usr/lib && cd /home && \
  wget --no-check-certificate -q https://cran.r-project.org/src/base/R-3/R-3.5.2.tar.gz && \
  tar -zxf R-3.5.2.tar.gz && \
  cd /home/R-3.5.2 && \
  export MKLROOT="/opt/intel/compilers_and_libraries_2019.1.144/linux" && \
  export LD_LIBRARY_PATH="${MKLROOT}/tbb/lib/intel64_lin/gcc4.7:${MKLROOT}/compiler/lib/intel64_lin:${MKLROOT}/mkl/lib/intel64_lin" && \
  export LIBRARY_PATH="$LD_LIBRARY_PATH" && \
  export MIC_LD_LIBRARY_PATH="${MKLROOT}/tbb/lib/intel64_lin_mic:${MKLROOT}/compiler/lib/intel64_lin_mic:${MKLROOT}/mkl/lib/intel64_lin_mic" && \
  export MIC_LIBRARY_PATH="$MIC_LD_LIBRARY_PATH" && \
  export CPATH="${MKLROOT}/mkl/include" && \
  export NLSPATH="${MKLROOT}/mkl/lib/intel64_lin/locale/%l_%t/%N" && \
  export MKL="-L${MKLROOT}/mkl/lib/intel64 -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm -ldl" && \
  ./configure CFLAGS="-g -O3" CPPFLAGS="-g -O3" FFLAGS="-g -O3" FCFLAGS="-g -O3 -m64 -I${MKLROOT}/mkl/include" --prefix=/opt/R --enable-R-shlib --enable-shared --enable-R-profiling --enable-memory-profiling --with-blas="$MKL" --with-lapack && \
  make && make install && cd /home && rm -Rf /home/R-* && \
  ln -s /opt/R/bin/R /usr/bin/R && \
  ln -s /opt/R/bin/Rscript /usr/bin/Rscript

RUN cd /home && \
  cd /home && \
  wget -q https://github.com/stevengj/nlopt/archive/v2.5.0.tar.gz && ls && \
  tar -zxf v2.5.0.tar.gz && ls && \
  cd nlopt-2.5.0 && \
  cmake -DCMAKE_CXX_FLAGS="-g -O3 -fPIC" && make && make install && \
  cd /home && rm -rf nlopt-* && \
  wget --no-check-certificate -q https://cran.r-project.org/src/contrib/Archive/kinship/kinship_1.1.3.tar.gz && \
  R CMD INSTALL --no-docs --no-demo --byte-compile kinship_1.1.3.tar.gz && \
  rm kinship_1.1.3.tar.gz && \
  cd /home && \
  echo "devtools,grImport,Rcpp,RcppEigen,R.utils,Matrix,zip,data.table,filematrix,plyr,reshape2,ggplot2,SuppDists,MASS,survival,car,mice,Hmisc" | tr ',' '\n' > /home/pkgs.txt && \
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

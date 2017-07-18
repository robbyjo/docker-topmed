# By Roby Joehanes
# License: GPL-3.0

FROM robbyjo/ubuntu-mkl:14.04.5-2017.3
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

# Easier way to build R dependencies are below, but this will result in a bulky build.
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y build-dep r-base-dev
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libcurl4-openssl-dev
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y remove libblas3 libblas-dev

# Leaner R because tex is not installed
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential libbz2-1.0 \
  libbz2-dev libjpeg-dev libncurses5-dev libpcre3-dev libpng-dev libreadline-dev \
  zlib1g-dev libcurl4-openssl-dev libcairo2 libcairo2-dev libglib2.0-0 libgomp1 libjpeg8 liblzma5 \
  libpango-1.0-0 libpangocairo-1.0-0 libpaper-utils libpng12-0 libreadline6 \
  libtcl8.5 libtiff5 libtk8.5 libx11-6 libxt6 tcl8.5 tk8.5 ucf unzip xdg-utils zip zlib1g \
  libx11-dev xorg-dev liblzma-dev libicu-dev libtiff5 libtiff5-dev && \
# Instead of relying on Ubuntu Trusty's libpcre 8.31 (which is deemed obsolete by R),
# Try to install 8.40 manually
  cd /home && wget -q ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz && \
  tar -zxf pcre-8.40.tar.gz && cd pcre-8.40 && \
  ./configure --enable-pcre16 --enable-pcre32 --enable-jit --enable-utf --enable-pcregrep-libz --enable-pcregrep-libbz2 --enable-pcretest-libreadline && \
  make && make install && cd /home && rm -rf /home/pcre-8.40* && \
  ln -sf /opt/intel/lib/intel64/libiomp*.so /usr/lib && cd /home && \
  wget --no-check-certificate -q https://cran.r-project.org/src/base/R-3/R-3.4.1.tar.gz && \
  tar -zxf R-3.4.1.tar.gz && \
  cd /home/R-3.4.1 && \
  export MKLROOT="/opt/intel/compilers_and_libraries_2017.4.196/linux" && \
  export LD_LIBRARY_PATH="${MKLROOT}/tbb/lib/intel64_lin/gcc4.7:${MKLROOT}/compiler/lib/intel64_lin:${MKLROOT}/mkl/lib/intel64_lin" && \
  export LIBRARY_PATH="$LD_LIBRARY_PATH" && \
  export MIC_LD_LIBRARY_PATH="${MKLROOT}/tbb/lib/intel64_lin_mic:${MKLROOT}/compiler/lib/intel64_lin_mic:${MKLROOT}/mkl/lib/intel64_lin_mic" && \
  export MIC_LIBRARY_PATH="$MIC_LD_LIBRARY_PATH" && \
  export CPATH="${MKLROOT}/mkl/include" && \
  export NLSPATH="${MKLROOT}/mkl/lib/intel64_lin/locale/%l_%t/%N" && \
  export MKL="-L${MKLROOT}/mkl/lib/intel64 -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm -ldl" && \
  ./configure CFLAGS="-g -O3" CPPFLAGS="-g -O3" FFLAGS="-g -O3" FCFLAGS="-g -O3 -m64 -I${MKLROOT}/mkl/include" --prefix=/opt/R --enable-R-shlib --enable-shared --enable-R-profiling --enable-memory-profiling --disable-java --with-blas="$MKL" --with-lapack && \
  make && make install && cd /home && rm -Rf /home/R-3.4.1* && \
  ln -s /opt/R/bin/R /usr/bin/R && \
  ln -s /opt/R/bin/Rscript /usr/bin/Rscript

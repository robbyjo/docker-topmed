# By Roby Joehanes
# License: GPL-3.0

FROM robbyjo/ubuntu-mkl:16.04-2018.0
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

# Easier way to build R dependencies are below, but this will result in a bulky build.
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y build-dep r-base-dev && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install libcurl4-openssl-dev sysstat && \
  DEBIAN_FRONTEND=noninteractive apt-get -y remove libblas3 libblas-dev && \
# Instead of relying on Ubuntu Trusty's libpcre 8.31 (which is deemed obsolete by R),
# Try to install 8.40 manually
  sed -e "s/false/true/g" /etc/default/sysstat > /etc/default/sysstat.bak && \
  mv /etc/default/sysstat.bak /etc/default/sysstat && \
  /etc/init.d/sysstat start && \
  cd /home && wget -q ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.40.tar.gz && \
  tar -zxf pcre-8.40.tar.gz && cd pcre-8.40 && \
  ./configure --enable-pcre16 --enable-pcre32 --enable-jit --enable-utf --enable-pcregrep-libz --enable-pcregrep-libbz2 --enable-pcretest-libreadline && \
  make && make install && cd /home && rm -rf /home/pcre-8.40* && \
  ln -sf /opt/intel/lib/intel64/libiomp*.so /usr/lib && cd /home && \
  wget --no-check-certificate -q https://cran.r-project.org/src/base/R-3/R-3.4.1.tar.gz && \
  tar -zxf R-3.4.1.tar.gz && \
  cd /home/R-3.4.1 && \
  export MKLROOT="/opt/intel/compilers_and_libraries_2018.0.128/linux" && \
  export LD_LIBRARY_PATH="${MKLROOT}/tbb/lib/intel64_lin/gcc4.7:${MKLROOT}/compiler/lib/intel64_lin:${MKLROOT}/mkl/lib/intel64_lin" && \
  export LIBRARY_PATH="$LD_LIBRARY_PATH" && \
  export MIC_LD_LIBRARY_PATH="${MKLROOT}/tbb/lib/intel64_lin_mic:${MKLROOT}/compiler/lib/intel64_lin_mic:${MKLROOT}/mkl/lib/intel64_lin_mic" && \
  export MIC_LIBRARY_PATH="$MIC_LD_LIBRARY_PATH" && \
  export CPATH="${MKLROOT}/mkl/include" && \
  export NLSPATH="${MKLROOT}/mkl/lib/intel64_lin/locale/%l_%t/%N" && \
  export MKL="-L${MKLROOT}/mkl/lib/intel64 -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm -ldl" && \
  ./configure CFLAGS="-g -O3" CPPFLAGS="-g -O3" FFLAGS="-g -O3" FCFLAGS="-g -O3 -m64 -I${MKLROOT}/mkl/include" --prefix=/opt/R --enable-R-shlib --enable-shared --enable-R-profiling --enable-memory-profiling --with-blas="$MKL" --with-lapack && \
  make && make install && cd /home && rm -Rf /home/R-3.4.1* && \
  ln -s /opt/R/bin/R /usr/bin/R && \
  ln -s /opt/R/bin/Rscript /usr/bin/Rscript

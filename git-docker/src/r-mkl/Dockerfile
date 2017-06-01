# By Roby Joehanes
# License: GPL-3.0

FROM robbyjo/ubuntu-mkl:14.04.5-2017.3
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

#RUN DEBIAN_FRONTEND=noninteractive apt-get -y build-dep r-base-dev
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libcurl4-openssl-dev
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y remove libblas3 libblas-dev

# Leaner R because tex is not installed
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential libbz2-1.0 \
  libbz2-dev libjpeg-dev libncurses5-dev libpcre3-dev libpng-dev libreadline-dev \
  zlib1g-dev libcurl4-openssl-dev libcairo2 libglib2.0-0 libgomp1 libjpeg8 liblzma5 \
  libpango-1.0-0 libpangocairo-1.0-0 libpaper-utils libpng12-0 libreadline6 \
  libtcl8.5 libtiff5 libtk8.5 libx11-6 libxt6 tcl8.5 tk8.5 ucf unzip xdg-utils zip zlib1g \
  libx11-dev xorg-dev liblzma-dev


RUN ln -sf /opt/intel/lib/intel64/libiomp.so /usr/lib && \
  cd /home && \
  wget --no-check-certificate -q https://cran.r-project.org/src/base/R-3/R-3.4.0.tar.gz && \
  tar -zxvf R-3.4.0.tar.gz

RUN cd /home/R-3.4.0 && \
  export MKLROOT="/opt/intel/compilers_and_libraries_2017.4.196/linux" && \
  export LD_LIBRARY_PATH="${MKLROOT}/tbb/lib/intel64_lin/gcc4.7:${MKLROOT}/compiler/lib/intel64_lin:${MKLROOT}/mkl/lib/intel64_lin" && \
  export LIBRARY_PATH="$LD_LIBRARY_PATH" && \
  export MIC_LD_LIBRARY_PATH="${MKLROOT}/tbb/lib/intel64_lin_mic:${MKLROOT}/compiler/lib/intel64_lin_mic:${MKLROOT}/mkl/lib/intel64_lin_mic" && \
  export MIC_LIBRARY_PATH="$MIC_LD_LIBRARY_PATH" && \
  export CPATH="${MKLROOT}/mkl/include" && \
  export NLSPATH="${MKLROOT}/mkl/lib/intel64lin/locale/%l%t/%N" && \
  export MKL="-L${MKLROOT}/mkl/lib/intel64 -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm -ldl" && \
  ./configure FCFLAGS="-m64 -I${MKLROOT}/mkl/include" --prefix=/opt/R --enable-shared --with-blas="$MKL" --with-lapack && \
  make && make install && rm -Rf /home/R-3.4.0*

RUN ln -s /opt/R/bin/R /usr/bin/R && \
ln -s /opt/R/bin/Rscript /usr/bin/Rscript

# By Roby Joehanes
# License: GPL-3.0

FROM ubuntu:14.04.5
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install gcc g++ gfortran wget

RUN cd /tmp && \
  wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/11544/l_mkl_2017.3.196.tgz && \
  tar -xzf l_mkl_2017.3.196.tgz && \
  cd l_mkl_2017.3.196 && \
  sed -i 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/g' silent.cfg && \
  sed -i 's/ARCH_SELECTED=ALL/ARCH_SELECTED=INTEL64/g' silent.cfg && \
#  sed -i 's/COMPONENTS=DEFAULTS/COMPONENTS=;intel-comp-l-all-vars__noarch;intel-openmp-l-all__x86_64;intel-openmp-l-ps-libs__x86_64;intel-openmp-l-ps-libs-jp__x86_64;intel-tbb-libs__noarch;intel-mkl-common__noarch;intel-mkl-sta-common__noarch;intel-mkl__x86_64;intel-mkl-rt__x86_64;intel-mkl-ps-rt-jp__x86_64;intel-mkl-doc__noarch;intel-mkl-ps-doc__noarch;intel-mkl-ps-doc-jp__noarch;intel-mkl-gnu__x86_64;intel-mkl-gnu-rt__x86_64;intel-mkl-ps-common__noarch;intel-mkl-ps-common-jp__noarch;intel-mkl-ps-common-64bit__x86_64;intel-mkl-common-c__noarch;intel-mkl-common-c-64bit__x86_64;intel-mkl-ps-common-c__noarch;intel-mkl-doc-c__noarch;intel-mkl-ps-doc-c-jp__noarch;intel-mkl-ps-ss-tbb__x86_64;intel-mkl-ps-ss-tbb-rt__x86_64;intel-mkl-gnu-c__x86_64;intel-mkl-ps-common-f__noarch;intel-mkl-ps-common-f-64bit__x86_64;intel-mkl-ps-doc-f__noarch;intel-mkl-ps-doc-f-jp__noarch;intel-mkl-ps-gnu-f-rt__x86_64;intel-mkl-ps-gnu-f__x86_64;intel-mkl-ps-f95-common__noarch;intel-mkl-ps-f__x86_64;intel-mkl-psxe__noarch;intel-psxe-common__noarch;intel-psxe-common-doc__noarch;intel-compxe-pset/g' silent.cfg && \
  sed -i 's/COMPONENTS=DEFAULTS/COMPONENTS=;intel-comp-l-all-vars__noarch;intel-openmp-l-all__x86_64;intel-openmp-l-ps-libs__x86_64;intel-tbb-libs__noarch;intel-mkl-common__noarch;intel-mkl-sta-common__noarch;intel-mkl__x86_64;intel-mkl-rt__x86_64;intel-mkl-gnu__x86_64;intel-mkl-gnu-rt__x86_64;intel-mkl-ps-common__noarch;intel-mkl-ps-common-64bit__x86_64;intel-mkl-common-c__noarch;intel-mkl-common-c-64bit__x86_64;intel-mkl-ps-common-c__noarch;intel-mkl-ps-ss-tbb__x86_64;intel-mkl-ps-ss-tbb-rt__x86_64;intel-mkl-gnu-c__x86_64;intel-mkl-ps-common-f__noarch;intel-mkl-ps-common-f-64bit__x86_64;intel-mkl-ps-gnu-f-rt__x86_64;intel-mkl-ps-gnu-f__x86_64;intel-mkl-ps-f95-common__noarch;intel-mkl-ps-f__x86_64;intel-mkl-psxe__noarch;intel-psxe-common__noarch;intel-compxe-pset/g' silent.cfg && \
  ./install.sh -s silent.cfg && \
  cd .. && rm -rf *

RUN rm -rf /opt/intel/.*.log /opt/intel/compilers_and_libraries_2017.4.196/licensing 

# It looks like the flags below will be conveniently ignored
#RUN echo "export MKLROOT=\"/opt/intel/compilers_and_libraries_2017.4.196/linux\"" >> /etc/profile && \
#  echo "export LD_LIBRARY_PATH=\"${MKLROOT}/tbb/lib/intel64_lin/gcc4.7:${MKLROOT}/compiler/lib/intel64_lin:${MKLROOT}/mkl/lib/intel64_lin\"" >> /etc/profile && \
#  echo "export LIBRARY_PATH=\"$LD_LIBRARY_PATH\"" >> /etc/profile && \
#  echo "export MIC_LD_LIBRARY_PATH=\"${MKLROOT}/tbb/lib/intel64_lin_mic:${MKLROOT}/compiler/lib/intel64_lin_mic:${MKLROOT}/mkl/lib/intel64_lin_mic\"" >> /etc/profile && \
#  echo "export MIC_LIBRARY_PATH=\"$MIC_LD_LIBRARY_PATH\"" >> /etc/profile && \
#  echo "export CPATH=\"${MKLROOT}/mkl/include\"" >> /etc/profile && \
#  echo "export NLSPATH=\"${MKLROOT}/mkl/lib/intel64lin/locale/%l%t/%N\"" >> /etc/profile && \
#  echo "export MKL=\"-L${MKLROOT}/mkl/lib/intel64 -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm -ldl\"" >> /etc/profile

RUN echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/intel.conf && \
  ldconfig && \
  echo "source /opt/intel/mkl/bin/mklvars.sh intel64" >> /etc/bash.bashrc

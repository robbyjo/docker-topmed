# By Roby Joehanes
# License: GPL-3.0

FROM ubuntu:14.04.5

# Get required dependencies for MKL
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install gcc g++ gfortran wget

# Install MKL silently
RUN cd /tmp && \
  wget -q http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/11544/l_mkl_2017.3.196.tgz && \
  tar -xzf l_mkl_2017.3.196.tgz && \
  cd l_mkl_2017.3.196 && \
  sed -i 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/g' silent.cfg && \
  ./install.sh -s silent.cfg && \
  cd .. && rm -rf *

# Add library path
RUN echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/intel.conf && \
  ldconfig && \
  echo "source /opt/intel/mkl/bin/mklvars.sh intel64" >> /etc/bash.bashrc


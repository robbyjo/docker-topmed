# By Roby Joehanes
# License: GPL-3.0

FROM robbyjo/ubuntu-mkl:16.04-2018.0
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

ENV PATH /opt/conda/bin:$PATH
ENV LANG C.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common python-software-properties \
  man unzip vim nano bc python3 python3-dev python3-pip python3-tk build-essential cmake curl git libglib2.0-0 \
  libxext6 libsm6 libxrender1 ca-certificates busybox fonts-ipaexfont && \
  /bin/busybox --install && \
  wget --no-check-certificate -q https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh && \
  bash /Anaconda3-4.2.0-Linux-x86_64.sh -b -p /opt/conda && \
  conda update -y conda && \
  conda update -y anaconda && \
  conda update -y mkl && \
  conda install -y numpy scipy matplotlib networkx scikit-learn jupyter blist bokeh blaze cython \
  statsmodels ncurses seaborn dask flask markdown sympy numexpr pandas path.py pygments six sphinx \
  wheel nose h5py ipykernel pydot-ng theano networkx pyyaml quandl pymongo && \
  pip install https://anaconda.org/intel/tensorflow/1.2.1/download/tensorflow-1.2.1-cp35-cp35m-linux_x86_64.whl \
  apt-get clean && apt-get autoremove

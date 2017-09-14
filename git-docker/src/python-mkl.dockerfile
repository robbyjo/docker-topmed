# By Roby Joehanes
# License: GPL-3.0

FROM robbyjo/ubuntu-mkl:16.04-2018.0
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install man python python-dev python-pip python-tk \
  bc build-essential cmake curl g++ gfortran git libffi-dev libfreetype6-dev libhdf5-dev libjpeg-dev \
  liblcms2-dev libopenjpeg-dev libpng12-dev libssl-dev libtiff5-dev libwebp-dev libzmq3-dev nano pkg-config \
  software-properties-common unzip vim zlib1g-dev qt5-default libvtk6-dev zlib1g-dev libjpeg-dev libwebp-dev \
  libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev libdc1394-22-dev libavcodec-dev \
  libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm \
  libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev libtbb-dev libeigen3-dev \
  ant default-jdk doxygen && \
  pip --no-cache-dir install Cython && \
  cd /tmp && wget --no-check-certificate -q https://github.com/numpy/numpy/releases/download/v1.13.1/numpy-1.13.1.tar.gz && \
  cd numpy-1.13.1 && cp site.cfg.example site.cfg && \
  echo "\n[mkl]" >> site.cfg && \
  echo "include_dirs = /opt/intel/mkl/include/intel64/" >> site.cfg && \
  echo "library_dirs = /opt/intel/mkl/lib/intel64/" >> site.cfg && \
  echo "mkl_libs = mkl_rt" >> site.cfg && \
  echo "lapack_libs =" >> site.cfg && \
  python setup.py build --fcompiler=gnu95 && \
  python setup.py install && \
  cd .. && rm -rf * && \
  cd /tmp && wget --no-check-certificate -q https://github.com/scipy/scipy/releases/download/v0.19.1/scipy-0.19.1.tar.gz && \
  cd scipy-0.19.1 && python setup.py build && python setup.py install && \
  cd .. && rm -rf * && \
  pip --no-cache-dir install pyopenssl ndg-httpsclient pyasn1 nose h5py ipykernel jupyter path.py Pillow pygments six sphinx wheel zmq && \
  python -m ipykernel.kernelspec && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install python-skimage python-matplotlib python-pandas python-sklearn python-sympy && \
  apt-get clean && apt-get autoremove

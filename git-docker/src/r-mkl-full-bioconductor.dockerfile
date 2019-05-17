# By Roby Joehanes
# License: GPL-3.0


FROM robbyjo/r-mkl-full-assoctool:3.5.2-18.04-2019.1
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

RUN cd /home && \
  wget https://raw.githubusercontent.com/robbyjo/docker-topmed/master/git-docker/src/install-bioc.R && \
  Rscript --vanilla /home/install-bioc.R && \
  rm -Rf /home/*

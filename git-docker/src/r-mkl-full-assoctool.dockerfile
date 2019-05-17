# By Roby Joehanes
# License: GPL-3.0


FROM robbyjo/r-mkl-full:3.5.2-18.04-2019.1
MAINTAINER Roby Joehanes <robbyjo@gmail.com>

RUN cd /home && \
  wget https://raw.githubusercontent.com/robbyjo/docker-topmed/master/git-docker/src/install-pkgs.R && \
  Rscript --vanilla /home/install-pkgs.R && \
rm -Rf /home/*

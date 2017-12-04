FROM ubuntu:16.04

ARG IMAGE_NAME
ARG IMAGE_VERSION

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

ARG apt_mirror=cz.archive.ubuntu.com
ARG apt_install="apt-get install -y --no-install-recommends"

RUN echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
RUN sed -i "s/archive.ubuntu.com/$apt_mirror/" /etc/apt/sources.list

RUN apt-get update
RUN $apt_install ca-cacert curl
RUN curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | apt-key add -
RUN curl https://www.virtualbox.org/download/oracle_vbox.asc | apt-key add -
RUN echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" > /etc/apt/sources.list.d/virtualbox.list

RUN apt-get update
RUN $apt_install kmod virtualbox-$IMAGE_VERSION

CMD virtualbox

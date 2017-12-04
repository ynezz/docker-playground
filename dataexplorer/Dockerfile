FROM openjdk:9-jre

ENV IMAGE_NAME dataexplorer
ARG IMAGE_VERSION

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

ARG apt_mirror=cz.archive.ubuntu.com
ARG apt_install="apt-get install -y --no-install-recommends"
ARG USER_UID=1000
ARG USER_GID=1000
ARG USER_NAME=foobar

RUN echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
RUN sed -i "s/archive.ubuntu.com/$apt_mirror/" /etc/apt/sources.list
RUN apt-get update
RUN $apt_install libcanberra-gtk3-module

ENV HOME /home/$USER_NAME
RUN groupadd --gid $USER_GID $USER_NAME
RUN useradd --create-home --home-dir $HOME --uid $USER_UID --gid $USER_GID $USER_NAME

RUN mkdir -p /opt/dataexplorer
ADD dataexplorer-$IMAGE_VERSION-bin_GNULinux_x86_64.tar.gz /opt/dataexplorer
COPY DataExplorer /opt/dataexplorer/DataExplorer/
RUN chown -R $USER_NAME:$USER_NAME /opt/dataexplorer
WORKDIR /opt/dataexplorer/DataExplorer

# TODO: Fix `/dev/bus/usb` permissions so we can run under USER_NAME
# USER $USER_NAME

CMD ./DataExplorer

################################################################################
#   Build stage 1
################################################################################
FROM ubuntu:latest as builder

USER root
ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US
ENV LC_ALL C
ENV SHELL /bin/bash
ENV BASH_ENV /etc/bash.bashrc
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp

#------------------------------------------------------------------------------#
#   Build arguments
#------------------------------------------------------------------------------#
ARG COMPILER
ARG SHARED=ON
ARG STATIC=OFF
ARG CXXSTD=11
ARG TIMEMORY=OFF
ARG BUILD_TYPE=Release
ARG SOFTWARE=geant4

#------------------------------------------------------------------------------#
#   ENVIRONMENT
#------------------------------------------------------------------------------#
ENV COMPILER        ${COMPILER}
ENV BUILD_TYPE      ${BUILD_TYPE}
ENV SHARED          ${SHARED}
ENV STATIC          ${STATIC}
ENV CXXSTD          ${CXXSTD}
ENV TIMEMORY        ${TIMEMORY}
ENV SOFTWARE        ${SOFTWARE}

#------------------------------------------------------------------------------#
#   copy files for build
#------------------------------------------------------------------------------#
COPY ./config/apt.sh /tmp/apt.sh
COPY ./config/${SOFTWARE}-config.cmake.in /tmp/${SOFTWARE}-config.cmake.in
COPY ./config/configure-file.cmake /tmp/configure-file.cmake
COPY ./config/${SOFTWARE}-build.sh /tmp/${SOFTWARE}-build.sh

#------------------------------------------------------------------------------#
#   primary install
#------------------------------------------------------------------------------#
RUN ./apt.sh && ./${SOFTWARE}-build.sh && rm -rf /tmp/*

#------------------------------------------------------------------------------#
#   interactive settings and startup
#------------------------------------------------------------------------------#
COPY ./config/etc/compute-dir-size.py /etc/compute-dir-size.py
COPY ./config/etc/profile.d/${SOFTWARE}.sh /etc/profile.d/
COPY ./config/etc/bash.bashrc /etc/bash.bashrc
COPY ./config/root/.bashrc /root/.bashrc

################################################################################
#   Build stage 2 - compress to 1 layer
################################################################################
FROM scratch

COPY --from=builder / /

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US
ENV LC_ALL C
ENV SHELL /bin/bash
ENV BASH_ENV /etc/bash.bashrc
ENV DEBIAN_FRONTEND noninteractive

USER root
WORKDIR /home
SHELL [ "/bin/bash", "--login", "-c" ]
ENTRYPOINT [ "/runtime-entrypoint.sh" ]

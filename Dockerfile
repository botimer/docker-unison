FROM phusion/baseimage:0.9.18
CMD ["/sbin/my_init"]

MAINTAINER Leigh McCulloch

# Upload Unison for building
COPY unison-2.40.102.tar.gz /tmp/unison/
COPY unison-2.48.3.tar.gz /tmp/unison/

# Build and install Unison versions then cleanup
COPY unison-install.sh .
RUN add-apt-repository -y ppa:avsm/ocaml42+opam12 \
 && apt-get update -y \
 && apt-get install -y ocaml-nox build-essential \
 && ./unison-install.sh \
 && apt-get purge -y ocaml-nox build-essential \
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Set default Unison configuration
ENV UNISON_VERSION=2.48.3
ENV UNISON_WORKING_DIR=/unison

# Set working directory to be the home directory
WORKDIR /root

# Setup unison to run as a service
VOLUME $UNISON_WORKING_DIR
COPY unison-run.sh /etc/service/unison/run
EXPOSE 5000

# VERSION               1
FROM      ubuntu
MAINTAINER Anders Einar Hilden <hildenae@gmail.com>

# Based on opennsm/suricata

# Metadata
LABEL organization=hild1
LABEL program=suricata
# Specify container username e.g. training, demo
ENV VIRTUSER user
# Specify program
ENV PROG suricata
# Specify Suricata version to download and install (e.g. 2.0.9)
ENV VERS 2.0.11
# Install directory 
ENV PREFIX /opt
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/bin

# Install dependencies
RUN apt-get update -qq
RUN apt-get install -yq libpcre3 libpcre3-dbg libpcre3-dev \
build-essential autoconf automake libtool libpcap-dev libnet1-dev \
libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libmagic-dev libcap-ng-dev \
libjansson-dev pkg-config libgeoip-dev libnetfilter-queue-dev

RUN apt-get install -yq wget

RUN useradd -ms /bin/bash $VIRTUSER

# Compile and install libpcap
USER $VIRTUSER
WORKDIR /home/$VIRTUSER
RUN wget http://www.openinfosecfoundation.org/download/$PROG-$VERS.tar.gz
RUN tar -xvzf $PROG-$VERS.tar.gz
WORKDIR /home/$VIRTUSER/$PROG-$VERS
RUN ./configure --enable-nfqueue --enable-geoip --prefix=$PREFIX --sysconfdir=/etc --localstatedir=/var && make
USER root
RUN make install && make install-full
RUN chmod u+s $PREFIX/bin/$PROG

# Cleanup
RUN rm -rf /home/$VIRTUSER/$PROG-$VERS

# Environment
WORKDIR /home/$VIRTUSER
USER $VIRTUSER

FROM resin/armv7hf-debian-qemu

RUN [ "cross-build-start" ]

WORKDIR /opt

ENV MICROHTTPD_VERSION 0.9.59

# Add the package verification key
RUN apt-get update \
 && apt-get upgrade \
 && apt-get install -y wget git supervisor \
 && mkdir -p /var/log/supervisor

RUN apt-get install -y build-essential libudev-dev libmicrohttpd-dev libgnutls28-dev
RUN wget -O libmicrohttpd.tar.gz https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-${MICROHTTPD_VERSION}.tar.gz \
 && tar zxvf libmicrohttpd.tar.gz && mv libmicrohttpd-${MICROHTTPD_VERSION} libmicrohttpd && rm libmicrohttpd.tar.gz \
 && cd libmicrohttpd && ./configure && make -j && make install
RUN ldconfig
RUN cd /opt \
 && git clone https://github.com/OpenZWave/open-zwave.git open-zwave \
 && cd open-zwave \
 && make
RUN cd /opt \
 && git clone https://github.com/OpenZwave/open-zwave-control-panel open-zwave-control-panel \
 && cd open-zwave-control-panel \
 && ln -sd ../open-zwave/config \
 && make
 # && mv /tmp/Makefile.PATCHED Makefile \

# remove several traces of debian python
RUN apt-get purge build-essential libudev-dev libmicrohttpd-dev libgnutls28-dev

RUN [ "cross-build-end" ]


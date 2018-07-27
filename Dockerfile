# Instructions for installation taken from the following site URL: 
# https://wiki.freeradius.org/guide/Getting-Started
FROM ubuntu:14.04

MAINTAINER Kadima Solutions
MAINTAINER opax@kadima.solutions

# Useful envinronment variables.
ENV \
RADIUS_HOME=/etc/freeradius

# These files/dirs can be mounted externally for persistence.
ENV \
CLIENT_CONFIG=${RADIUS_HOME}/clients.conf \
USERS_CONFIG=${RADIUS_HOME}/mods-config/files/authorize

RUN set -x \
&& apt-key adv --keyserver keys.gnupg.net --recv-key 0x41382202 \
&& apt-get update \
&& apt-get install -y curl rpm \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN set -x \
&& mkdir -p /etc/pki/rpm-gpg \
&& rpm --import https://ltb-project.org/lib/RPM-GPG-KEY-LTB-project \
&& gpg --keyserver keys.gnupg.net --recv-key 0x41382202 \
&& gpg --armor --export packages@networkradius.com > /etc/pki/rpm-gpg/packages.networkradius.com.gpg \
&& echo deb http://packages.networkradius.com/ubuntu trusty main >> /etc/apt/sources.list \
&& apt-get update \
&& apt-get install -y freeradius \
&& apt-get clean && rm -rf /var/lib/apt/lists/* \
&& freeradius -v

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY rad-cfg.sh /rad-cfg.sh
RUN set -x \
&& chmod 740 /docker-entrypoint.sh \
&& chmod 740 /rad-cfg.sh

EXPOSE 1812-1813/udp

# Run this container as a program
ENTRYPOINT ["/docker-entrypoint.sh"]

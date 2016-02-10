# ElasticPotPY Dockerfile by MO & MS
#
# VERSION 16.03.3
FROM ubuntu:14.04.3
MAINTAINER MS

ENV DEBIAN_FRONTEND noninteractive

# Setup apt
RUN ln -snf /bin/bash /bin/sh && \
    apt-get update -y && \
    apt-get upgrade -y

# Install packages
RUN apt-get install -y python python-setuptools supervisor git && \
    easy_install bottle requests configparser && \
    cd /opt/ && git clone https://github.com/schmalle/ElasticpotPY.git

# Setup user, groups and configs
RUN addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/bin/supervisord"]

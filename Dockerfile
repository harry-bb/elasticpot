# ElasticPotPY Dockerfile by MO & MS
#
# VERSION 17.06
FROM debian:jessie-slim
MAINTAINER MS

ENV DEBIAN_FRONTEND noninteractive

# Include dist
ADD dist/ /root/dist/

# Setup apt
RUN ln -snf /bin/bash /bin/sh && \
    apt-get update -y && \
    apt-get upgrade -y && \

# Install packages
    apt-get install -y python3 python3-setuptools supervisor git && \
    easy_install3 bottle requests configparser datetime && \
    cd /opt/ && git clone https://github.com/schmalle/ElasticpotPY.git && \

# Setup user, groups and configs
    addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \
    mkdir -p /data/ews/conf/ && \
    mv /root/dist/supervisord.conf /etc/supervisor/conf.d/ && \
    mv /root/dist/ews.cfg /data/ews/conf/ && \

# Clean up
    rm -rf /root/* && \
    apt-get purge git -y && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start elasticpot
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]

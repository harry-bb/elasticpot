# ElasticPot Dockerfile by MS/MO
#
# VERSION 16.03.1
FROM java:openjdk-8
MAINTAINER MS

# Setup env and apt
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
RUN apt-get update -y && \
    apt-get dist-upgrade -y

# Get and install packages
RUN ln -snf /bin/bash /bin/sh && \
    apt-get install -y redis-server supervisor git openssh-server
RUN cd /opt/ && \
    git clone https://github.com/schmalle/ElasticPot.git

# Setup user, groups and configs
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \
    # This is only needed to download all needed libraries for grails 2.5.3
    cd /opt/ElasticPot && \
    ./gradlew war

# Clean up
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start ElasticPot
WORKDIR /opt/ElasticPot/
CMD ["/usr/bin/supervisord"]

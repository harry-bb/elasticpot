#!/usr/bin/env bash

redis-server &
cd /data/ElasticPot
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
./gradlew -Dgrails.env=production run

